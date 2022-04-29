# PPS

PowerShell module: Interact with Pleasant Password Server API.

## Usage

### Examples

```powershell
################################### Examples ###################################

# Connect to Pleasant Password Server
Connect-Pps -Uri https://password.company.tld:10001

# Get ID of private folder
$allGroups = Get-PpsGroup -All
$privateId = $allGroups.Children.Where({$_.Name -eq 'Private Folders'}).Item(0).Children.Item(0).Id

# Create new credential entry in the private folder
$credId = New-PpsEntry -GroupId $privateId -Name 'Name Of Password Entry' -Username 'username' -Password 'P@ssw0rd' | Select-Object -ExpandProperty Id

# Get credential entry
$cred = Get-PpsEntry -Id $credId

# Change credential entry
$cred.Name = 'New Name'
Set-PpsEntry -Entry $cred

# Get info about credentials in a folder
(Get-PpsGroup -Id aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee).Credentials | Select-Object -Property Id,Name,Username


# Copy folder structure (not entries, only folders)
$SrcGroupId = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
$DstGroupId = '11111111-2222-3333-4444-555555555555'
function ProcessGroup ($SrcGroupId, $DstGroupId)
{
    $Group = Get-PpsGroup -Id $SrcGroupId
    foreach ($Child in $Group.Children)
    {
        "Creating $DstGroupId -> $($Child.Name)"
        $newChild = New-PpsGroup -ParentId $DstGroupId -Name $Child.Name
        ProcessGroup -SrcGroupId $Child.Id -DstGroupId $newChild.Id
    }
}
ProcessGroup -SrcGroupId $SrcGroupId -DstGroupId $DstGroupId

# Sync from one folder to another
Export-PpsEntry -RootPath 'Root/Private Folders/xxx/export' | Import-PpsEntry -RootPath 'Root/Private Folders/xxx/import'



########## Pleasant Password Server to Pleasant Password Server sync ###########

# Connect to first Pleasant Password Server
Connect-Pps -Uri password1.company.tld -Session s1

# Connect to second Pleasant Password Server
Connect-Pps -Uri password2.company.tld -Session s2

# Sync from first to second Pleasant Password Server
Export-PpsEntry -Session s1 -RootPath 'Root/Private Folders/xxx/export' | Import-PpsEntry -Session s2 -RootPath 'Root/Private Folders/xxx/import'



################### KeePass to Pleasant Password Server sync ###################

# Install KeePassImportExport module
Install-Module -Name KeePassImportExport -Scope CurrentUser

# Connect to KeePass database
$kdbx = Get-Item -Path C:\path\to\keepass\file.kdbx
$masterKey = Get-Credential -Message MasterKey -UserName NOT_USED
$db = $kdbx.BaseName
if (-not (Get-KeePassDatabaseConfiguration -DatabaseProfileName $db))
{
    New-KeePassDatabaseConfiguration -DatabaseProfileName $db -DatabasePath $kdbx.FullName -UseMasterKey
}

# Connect to Pleasant Password Server
Connect-Pps -Uri password.company.tld

# Sync from KeePass to Pleasant Password Server
Export-KeePassEntry -RootPath toplevel/export -DatabaseProfileName $db -MasterKey $masterKey | Import-PpsEntry -RootPath 'Root/Private Folders/xxx/import'



################### Pleasant Password Server to KeePass sync ###################

# Install KeePassImportExport module
Install-Module -Name KeePassImportExport -Scope CurrentUser

# Connect to KeePass database
$kdbx = Get-Item -Path C:\path\to\keepass\file.kdbx
$masterKey = Get-Credential -Message MasterKey -UserName NOT_USED
$db = $kdbx.BaseName
if (-not (Get-KeePassDatabaseConfiguration -DatabaseProfileName $db))
{
    New-KeePassDatabaseConfiguration -DatabaseProfileName $db -DatabasePath $kdbx.FullName -UseMasterKey
}

# Connect to Pleasant Password Server
Connect-Pps -Uri password.company.tld

# Sync from Pleasant Password Server to KeePass
Export-PpsEntry -RootPath 'Root/Private Folders/xxx/import' | Import-KeePassEntry -RootPath toplevel/import -DatabaseProfileName $db -MasterKey $masterKey

```

Examples are also found in [EXAMPLES.ps1](EXAMPLES.ps1).

### Functions

See [FUNCTIONS.md](FUNCTIONS.md) for documentation of functions in this module.

## Install

### Install module from PowerShell Gallery

```powershell
Install-Module PPS
```

### Install module from source

```powershell
git clone https://github.com/thordreier/PPS.git
cd PPS
git pull
.\Build.ps1 -InstallModule
```
