# Run this on the OWNER laptop, from PowerShell. Exports powered-off Ubuntu and Debian current states as portable OVA files.
# Does not delete originals, does not preserve snapshots in OVAs, and excludes Windows by default for licensing reasons.
param([string]$OutputFolder = 'E:\ISSD_CAT2\SharedExports\Deploy', [switch]$IncludeWindows)
$ErrorActionPreference = 'Stop'
$vbox = Join-Path $env:ProgramFiles 'Oracle\VirtualBox\VBoxManage.exe'
if (-not (Test-Path $vbox)) { throw 'VBoxManage.exe not found. Check VirtualBox installation.' }
New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null
$names = @('ISSD-CAT2-ubuntu','ISSD-CAT2-debian')
if ($IncludeWindows) {
    Write-Warning 'Windows redistribution may be restricted by Microsoft evaluation licensing. Confirm permission BEFORE making/sharing a Windows appliance.'
    $confirm = Read-Host 'Have you verified the license permits distribution to your recipients? Type YES to proceed'
    if ($confirm -ne 'YES') { throw 'Windows export cancelled; no files removed.' }
    $names += 'ISSD-CAT2-windows'
}
$sumEntries = @()
foreach ($name in $names) {
    $info = (& $vbox showvminfo $name --machinereadable | Out-String)
    if ($LASTEXITCODE -ne 0) { throw "VM not found: $name" }
    if ($info -notmatch '(?m)^VMState="poweroff"') { throw "Shut down $name cleanly first (currently not powered off)." }
    $file = Join-Path $OutputFolder ($name + '.ova')
    if (Test-Path -LiteralPath $file) { throw "Won't overwrite an existing export: $file. Move/rename the previous export first." }
    Write-Host "Exporting current state: $name -> $file"
    & $vbox export $name "--output=$file"
    if ($LASTEXITCODE -ne 0) { throw "Export failed: $name" }
    $sumEntries += ('{0}  {1}' -f (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash.ToLowerInvariant(), ($name + '.ova'))
}
$sum = Join-Path $OutputFolder 'SHA256SUMS.txt'
if (Test-Path $sum) { throw "Checksum file already exists: $sum. Move it before creating a new release." }
Set-Content -LiteralPath $sum -Value $sumEntries -Encoding ASCII
Write-Host "Done. Upload the Deploy folder's OVA files and SHA256SUMS.txt to a restricted-access Google Drive folder."
Write-Host 'Snapshots remain in the originals and are NOT included in an OVA. Preserve originals and/or separate offline snapshot backups.'
