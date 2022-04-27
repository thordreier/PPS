# PPS

PowerShell module: Interact with Pleasant Password Server API.

## Usage

### Examples

```powershell
# Connect to Pleasant Password Server
Connect-Pps -Uri https://password.company.tld:10001

# Get ID of private folder
$allGroups = Get-PpsGroup
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
