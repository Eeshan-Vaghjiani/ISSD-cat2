# Run without importing or starting VMs: powershell -NoProfile -File .\tools\test-setup-safety.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$tokens = $null
$errors = $null
$ast = [System.Management.Automation.Language.Parser]::ParseFile((Join-Path $root 'setup.ps1'), [ref]$tokens, [ref]$errors)
if ($errors.Count) { throw ($errors | Out-String) }
function Assert($condition, [string]$message) { if (-not $condition) { throw $message } }
function Stop-Setup([string]$message) { throw $message }
function Run([string]$exe, [string[]]$arguments) { $script:calls.Add(($arguments -join '|')) }

# Exercise the actual verification and network loops, with VBoxManage replaced by a recorder.
$loops = $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.ForEachStatementAst] }, $true)
$verify = $loops | Where-Object { $_.Variable.Extent.Text -eq '$f' -and $_.Extent.Text.Contains('Checksum mismatch') }
$network = $loops | Where-Object { $_.Variable.Extent.Text -eq '$name' -and $_.Extent.Text.Contains('--nic1=nat') }
Assert ($null -ne $verify -and $null -ne $network) 'Setup safety loops not found.'
$download = Join-Path ([IO.Path]::GetTempPath()) ('issd-setup-test-' + [guid]::NewGuid())
New-Item -ItemType Directory -Path $download | Out-Null
try {
    $files = @(@{ File='ISSD-CAT2-ubuntu.ova'; Required=$true })
    $path = Join-Path $download $files[0].File
    Set-Content -LiteralPath $path -Value 'test appliance only'
    $manifestFile = Join-Path $download 'SHA256SUMS.txt'
    Set-Content -LiteralPath $manifestFile -Value 'invalid manifest'
    $manifest = @{}
    $failed = $false
    try { & ([scriptblock]::Create($verify.Extent.Text)) } catch { $failed = $_.Exception.Message -like '*no valid entry*' }
    Assert $failed 'An incomplete supplied manifest must block import.'
    $manifest[$files[0].File] = '0' * 64
    $failed = $false
    try { & ([scriptblock]::Create($verify.Extent.Text)) } catch { $failed = $_.Exception.Message -like '*Checksum mismatch*' }
    Assert $failed 'A bad hash must block import.'
    $manifest[$files[0].File] = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
    & ([scriptblock]::Create($verify.Extent.Text))

    $imported = @('test-vm')
    $vbox = 'mock-vbox'
    foreach ($hostIf in @($null, 'test-host-only')) {
        $script:calls = [System.Collections.Generic.List[string]]::new()
        & ([scriptblock]::Create($network.Extent.Text))
        Assert ($calls[0].Contains('--nic1=nat|--nic2=none|--nic3=none|--nic4=none|--nic5=none|--nic6=none|--nic7=none|--nic8=none')) 'Imported external adapters must be disabled before host-only attachment.'
        if ($hostIf) { Assert ($calls[1].Contains('--nic2=hostonly')) 'Expected host-only attachment.' }
        else { Assert (-not (($calls -join '|').Contains('--nic2=hostonly'))) 'No host-only attachment without an adapter.' }
    }
    $hostIf = 'test-host-only'
    function Run([string]$exe, [string[]]$arguments) {
        if ($arguments -contains '--nic2=hostonly') { throw 'Mock attachment failure' }
        $script:calls.Add(($arguments -join '|'))
    }
    $script:calls.Clear()
    & ([scriptblock]::Create($network.Extent.Text))
    Assert ($calls[0].Contains('--nic2=none|--nic3=none')) 'Failed host-only attachment must leave secondary adapters disabled.'
    Write-Host 'PASS: missing checksum, bad checksum, valid checksum and all three imported-network paths.'
} finally {
    Remove-Item -LiteralPath $path,$manifestFile -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $download
}
