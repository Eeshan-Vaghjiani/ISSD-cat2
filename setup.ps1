# ISSD CAT 2 - interactive one-launch setup. Tested by inspection; real Drive/VBox import must be tested on Windows.
# Requires Windows x64, admin approval for VirtualBox install, and Google sign-in for Drive download.
# Never deletes, unregisters, restores, or overwrites an existing VM.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
function Say([string]$s) { Write-Host "`n==> $s" -ForegroundColor Cyan }
function Stop-Setup([string]$s) { throw $s }
function Run([string]$exe, [string[]]$arguments) {
    & $exe @arguments
    if ($LASTEXITCODE -ne 0) { Stop-Setup "$exe failed with exit code $LASTEXITCODE" }
}
function Find-VBox {
    $a = Join-Path $env:ProgramFiles 'Oracle\VirtualBox\VBoxManage.exe'
    if (Test-Path -LiteralPath $a) { return $a }
    $cmd = Get-Command VBoxManage.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}
function Find-Rclone {
    $cmd = Get-Command rclone.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    foreach ($p in @(
        (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\rclone.exe'),
        'C:\Program Files\rclone\rclone.exe',
        (Join-Path $env:USERPROFILE 'scoop\shims\rclone.exe')
    )) { if (Test-Path -LiteralPath $p) { return $p } }
    return $null
}
function Ask-Path([string]$prompt, [string]$suggested) {
    $v = Read-Host "$prompt [default: $suggested]"
    if ([string]::IsNullOrWhiteSpace($v)) { $v = $suggested }
    return $v.Trim().Trim('"')
}
if (-not [Environment]::Is64BitOperatingSystem) { Stop-Setup 'This kit requires a 64-bit Windows host.' }
Say 'Choose storage on a drive with enough free space for OVA downloads AND imported VMs'
$defaultRoot = if (Test-Path 'E:\') { 'E:\ISSD_CAT2_Group' } else { Join-Path $env:USERPROFILE 'ISSD_CAT2_Group' }
$root = Ask-Path 'Storage directory (prefer another SSD, not C:)' $defaultRoot
$root = [IO.Path]::GetFullPath($root)
$download = Join-Path $root 'Downloads'
$vmFolder = Join-Path $root 'VMs'
New-Item -ItemType Directory -Force -Path $download,$vmFolder | Out-Null
$driveName = [IO.Path]::GetPathRoot($root).TrimEnd('\').TrimEnd(':')
$free = (Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue).Free
if ($null -ne $free -and $free -lt 25GB) { Write-Warning 'Less than 25 GiB free; OVA downloads and VM imports may run out of space.' }
Say 'Find or install Oracle VirtualBox'
$vbox = Find-VBox
if (-not $vbox) {
    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        Stop-Setup 'VirtualBox is missing and winget is unavailable. Install VirtualBox from https://www.virtualbox.org/wiki/Downloads then rerun setup.bat.'
    }
    Write-Host 'VirtualBox is missing. WinGet will request any necessary Windows administrator approval.'
    Run 'winget.exe' @('install','--id','Oracle.VirtualBox','--exact','--source','winget','--accept-package-agreements','--accept-source-agreements')
    $vbox = Find-VBox
    if (-not $vbox) { Stop-Setup 'VirtualBox installation did not expose VBoxManage yet. Restart Windows if requested, then rerun setup.bat.' }
}
Write-Host "VirtualBox found: $vbox"
Say 'Choose the Google Drive download method'
Write-Host '1) Download VM appliances from the shared Google Drive folder using rclone (Google sign-in required)'
Write-Host '2) Use .ova appliances already downloaded from Google Drive (simpler fallback)'
$mode = Read-Host 'Enter 1 or 2 [1]'
if ([string]::IsNullOrWhiteSpace($mode)) { $mode = '1' }
if ($mode -eq '2') {
    $download = Ask-Path 'Full folder containing the .ova files' $download
    if (-not (Test-Path -LiteralPath $download)) { Stop-Setup "Folder not found: $download" }
} elseif ($mode -eq '1') {
    $rclone = Find-Rclone
    if (-not $rclone) {
        if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
            Stop-Setup 'rclone is missing. Install it from https://rclone.org/install/ or download the OVAs manually and choose option 2.'
        }
        Say 'Install rclone for resumable Google Drive transfers'
        Run 'winget.exe' @('install','--id','Rclone.Rclone','--exact','--source','winget','--accept-package-agreements','--accept-source-agreements')
        $rclone = Find-Rclone
        if (-not $rclone) { Stop-Setup 'rclone installed but cannot be found in this session. Reopen setup.bat and try again.' }
    }
    Write-Host 'You must sign in with a Google account that has Viewer access to the group assets.'
    $remotes = @(& $rclone listremotes)
    if ($LASTEXITCODE -ne 0) { Stop-Setup 'Cannot inspect rclone configuration.' }
    if (-not $remotes) {
        Write-Host 'One-time setup: choose n (new), name it issd, storage type drive, and complete browser authorization.'
        Write-Host 'As of 2026, rclone may require your group to configure its own Google OAuth client ID.'
        Run $rclone @('config')
        $remotes = @(& $rclone listremotes)
    }
    $remote = Read-Host ('Existing rclone Google Drive remote name (without colon) [' + (($remotes | Select-Object -First 1) -replace ':$','') + ']')
    if ([string]::IsNullOrWhiteSpace($remote)) { $remote = ($remotes | Select-Object -First 1) -replace ':$','' }
    if (-not $remote -or ($remote + ':') -notin $remotes) { Stop-Setup 'The selected rclone remote does not exist. Run rclone config, then rerun.' }
    $folderLink = Read-Host 'Paste the Google Drive DEPLOY folder link (shared with your account as Viewer)'
    if ($folderLink -match 'drive\.google\.com/drive/(?:u/\d+/)?folders/([A-Za-z0-9_-]+)') { $folderId = $Matches[1] }
    elseif ($folderLink -match '^[A-Za-z0-9_-]{15,}$') { $folderId = $folderLink }
    else { Stop-Setup 'Expected a Google Drive folder URL or folder ID. Do not paste a single file link.' }
    Say 'Download deployment appliances from Google Drive (this can be resumed by rerunning setup.bat)'
    Run $rclone @('copy',"${remote}:",$download,"--drive-root-folder-id=$folderId",'--progress','--checksum')
} else { Stop-Setup 'Choose download option 1 or 2.' }

Say 'Check the VM appliance files and optional integrity manifest'
$files = @(
    @{ Name='ISSD-CAT2-ubuntu'; File='ISSD-CAT2-ubuntu.ova'; Required=$true },
    @{ Name='ISSD-CAT2-debian'; File='ISSD-CAT2-debian.ova'; Required=$true },
    @{ Name='ISSD-CAT2-windows'; File='ISSD-CAT2-windows.ova'; Required=$false }
)
$manifestFile = Join-Path $download 'SHA256SUMS.txt'
$manifest = @{}
if (Test-Path -LiteralPath $manifestFile) {
    foreach ($line in Get-Content -LiteralPath $manifestFile) {
        if ($line -match '^([A-Fa-f0-9]{64})\s+\*?(.+)$') { $manifest[$Matches[2].Trim()] = $Matches[1].ToLowerInvariant() }
    }
} else { Write-Warning 'No SHA256SUMS.txt present: integrity verification unavailable. Ask the lab owner to publish checksums.' }
foreach ($f in $files) {
    $path = Join-Path $download $f.File
    if ($f.Required -and -not (Test-Path -LiteralPath $path)) { Stop-Setup "Missing required appliance: $path" }
    if (Test-Path -LiteralPath $path) {
        if ($manifest.ContainsKey($f.File)) {
            Write-Host "Verifying SHA256 for $($f.File) ..."
            $digest = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
            if ($digest -ne $manifest[$f.File]) { Stop-Setup "Checksum mismatch for $($f.File). Do not import; redownload." }
        } elseif (Test-Path -LiteralPath $manifestFile) {
            Stop-Setup "SHA256SUMS.txt has no valid entry for $($f.File). Ask the owner for a complete manifest before importing."
        }
    }
}
Say 'Import missing machines only; existing registered VMs will NEVER be replaced'
$registered = @(& $vbox list vms)
if ($LASTEXITCODE -ne 0) { Stop-Setup 'VBoxManage cannot list VMs; check the VirtualBox installation.' }
$imported = @()
$allNames = @()
foreach ($f in $files) {
    $path = Join-Path $download $f.File
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $name = $f.Name
    if ($registered | Where-Object { $_ -like ('"' + $name + '" *') }) {
        Write-Host "Skipping registered VM: $name"
        $allNames += $name
        continue
    }
    Write-Host "Importing $name (large disk files may take some time)..."
    Run $vbox @('import',$path,'--vsys=0',"--vmname=$name","--basefolder=$vmFolder")
    $imported += $name
    $allNames += $name
}
if (-not $allNames) { Stop-Setup 'No matching .ova files found. Nothing was imported.' }
Say 'Configure imported network adapters safely'
$ifRaw = (& $vbox list hostonlyifs | Out-String)
$hostIf = $null
if ($LASTEXITCODE -eq 0) {
    foreach ($block in ($ifRaw -split '(?:\r?\n){2,}')) {
        if ($block -match '(?m)^IPAddress:\s*192\.168\.56\.1\s*$' -and $block -match '(?m)^Name:\s*(.+)$') {
            $hostIf = $Matches[1].Trim()
            break
        }
    }
}
foreach ($name in $imported) {
    # Reset external networking to NAT + host-only only, never bridged.
    Run $vbox @('modifyvm',$name,'--nic1=nat','--nic2=none','--nic3=none','--nic4=none','--nic5=none','--nic6=none','--nic7=none','--nic8=none','--boot1=disk','--boot2=dvd','--boot3=none','--boot4=none')
    if ($hostIf) {
        try {
            Run $vbox @('modifyvm',$name,'--nic2=hostonly',("--host-only-adapter2=$hostIf"))
            Write-Host "Attached $name to host-only adapter $hostIf"
        } catch {
            Write-Warning "Could not set Adapter 2 automatically for $name. Set it manually to the 192.168.56.0/24 host-only network. $($_.Exception.Message)"
        }
    } else {
        Write-Warning 'No preconfigured VirtualBox host-only interface at 192.168.56.1 found.'
        Run $vbox @('modifyvm',$name,'--nic2=none')
    }
}
Say 'Setup results'
Write-Host ('VMs available: ' + ($allNames -join ', '))
Write-Host "Appliances directory: $download"
Write-Host "VirtualBox VM directory: $vmFolder"
Write-Host 'Open VirtualBox and confirm each imported VM uses Adapter 1 NAT and Adapter 2 the SAME host-only network at 192.168.56.0/24.'
Write-Host 'If host-only was not configured, use VirtualBox Tools -> Network -> Host-only Networks to create 192.168.56.1/24, then VM Settings -> Network -> Adapter 2.'
Write-Host 'Imported systems are NOT Vagrant-managed. Do not run vagrant up against these imports.'
Write-Host 'Never restore an old snapshot or clone registered Wazuh agents without re-enrollment/new agent identities.'
Write-Host 'Wazuh manager registration is NOT automatic: Member 5 must supply a reachable manager address and enrollment details.'
Write-Host 'If Windows VM is present, verify its evaluation license and recheck its 192.168.56.13 host-only IP after the import.'
