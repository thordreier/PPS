# PPS

Text in this document is automatically created - don't change it manually

## Index

[Connect-Pps](#Connect-Pps)<br>
[Get-PpsEntry](#Get-PpsEntry)<br>
[Get-PpsGroup](#Get-PpsGroup)<br>
[Invoke-PpsApiRequest](#Invoke-PpsApiRequest)<br>
[New-PpsEntry](#New-PpsEntry)<br>
[New-PpsGroup](#New-PpsGroup)<br>
[Update-PpsEntry](#Update-PpsEntry)<br>

## Functions

<a name="Connect-Pps"></a>
### Connect-Pps

```

NAME
    Connect-Pps
    
SYNOPSIS
    Connect to Pleasant Password Server
    
    
SYNTAX
    Connect-Pps [-Uri] <String> [-Session <String>] [<CommonParameters>]
    
    Connect-Pps [-Uri] <String> -Credential <PSCredential> [-Session <String>] [<CommonParameters>]
    
    Connect-Pps [-Uri] <String> -Username <String> -Password <String> [-Session <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Connect to Pleasant Password Server
    

PARAMETERS
    -Uri <String>
        URI of server to connect to, eg. https://password.company.tld:10001
        
    -Credential <PSCredential>
        Credential object with username and password used to connect to Pleasant Password Server with
        
    -Username <String>
        Username used to connect to Pleasant Password Server with
        
    -Password <String>
        Password used to connect to Pleasant Password Server with
        
    -Session <String>
        Makes it possible to connect to multiple Pleasant Password Servers
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Connect-Pps -Uri https://password.company.tld:10001
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Connect-Pps -examples".
    For more information, type: "get-help Connect-Pps -detailed".
    For technical information, type: "get-help Connect-Pps -full".

```

<a name="Get-PpsEntry"></a>
### Get-PpsEntry

```
NAME
    Get-PpsEntry
    
SYNOPSIS
    Get credential entry from Pleasant Password Server
    
    
SYNTAX
    Get-PpsEntry [-Id] <Guid> [-Session <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Get credential entry from Pleasant Password Server
    

PARAMETERS
    -Id <Guid>
        ID of entry to get info about
        
    -Session <String>
        Makes it possible to connect to multiple Pleasant Password Servers
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-PpsEntry -Id 5cbfabe7-70ee-4041-a1e0-263c9170f650
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-PpsEntry -examples".
    For more information, type: "get-help Get-PpsEntry -detailed".
    For technical information, type: "get-help Get-PpsEntry -full".

```

<a name="Get-PpsGroup"></a>
### Get-PpsGroup

```
NAME
    Get-PpsGroup
    
SYNOPSIS
    Get credential group (folder) from Pleasant Password Server
    
    
SYNTAX
    Get-PpsGroup [[-Id] <Guid>] [-Session <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Get credential group (folder) from Pleasant Password Server
    

PARAMETERS
    -Id <Guid>
        ID of group to get info about
        
    -Session <String>
        Makes it possible to connect to multiple Pleasant Password Servers
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-PpsGroup
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-PpsGroup -Id f6190167-a9a1-4386-a8cd-ae46008c9188
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-PpsGroup -examples".
    For more information, type: "get-help Get-PpsGroup -detailed".
    For technical information, type: "get-help Get-PpsGroup -full".

```

<a name="Invoke-PpsApiRequest"></a>
### Invoke-PpsApiRequest

```
NAME
    Invoke-PpsApiRequest
    
SYNOPSIS
    Invoke API request against Pleasant Password Server
    
    
SYNTAX
    Invoke-PpsApiRequest [-Uri] <String> [[-Method] {Default | Get | Head | Post | Put | Delete | Trace | Options | Merge | Patch}] [[-Data] <Object>] [[-Session] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Invoke API request against Pleasant Password Server
    

PARAMETERS
    -Uri <String>
        xxx
        
    -Method
        xxx
        
    -Data <Object>
        xxx
        
    -Session <String>
        Makes it possible to connect to multiple Pleasant Password Servers
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>xxx
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Invoke-PpsApiRequest -examples".
    For more information, type: "get-help Invoke-PpsApiRequest -detailed".
    For technical information, type: "get-help Invoke-PpsApiRequest -full".

```

<a name="New-PpsEntry"></a>
### New-PpsEntry

```
NAME
    New-PpsEntry
    
SYNOPSIS
    Create new credential entry in Pleasant Password Server
    
    
SYNTAX
    New-PpsEntry -Entry <PSObject> [-Session <String>] [<CommonParameters>]
    
    New-PpsEntry -GroupId <Guid> [-Name <String>] [-Username <String>] [-Password <String>] [-Url <String>] [-Notes <String>] [-Session <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Create new credential entry in Pleasant Password Server
    

PARAMETERS
    -Entry <PSObject>
        Object with data to create in Pleasant Password Server
        
    -GroupId <Guid>
        ID of credential group to create credential entry in
        
    -Name <String>
        Name of credential in Pleasant Password Server
        
    -Username <String>
        Username of credential in Pleasant Password Server
        
    -Password <String>
        Password of credential in Pleasant Password Server
        
    -Url <String>
        Url of credential in Pleasant Password Server
        
    -Notes <String>
        Notes of credential in Pleasant Password Server
        
    -Session <String>
        Makes it possible to connect to multiple Pleasant Password Servers
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>New-PpsEntry -GroupId f6190167-a9a1-4386-a8cd-ae46008c9188 -Name name -Username uname -Password pw -Url http://abc -Notes "This i a note"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>@{GroupId='f6190167-a9a1-4386-a8cd-ae46008c9188'; Name='name'; Username='user'; Password='pw'} | New-PpsEntry
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-PpsEntry -examples".
    For more information, type: "get-help New-PpsEntry -detailed".
    For technical information, type: "get-help New-PpsEntry -full".

```

<a name="New-PpsGroup"></a>
### New-PpsGroup

```
NAME
    New-PpsGroup
    
SYNOPSIS
    Create new credential group (folder) from Pleasant Password Server
    
    
SYNTAX
    New-PpsGroup -Group <PSObject> [-Session <String>] [<CommonParameters>]
    
    New-PpsGroup -ParentId <Guid> -Name <String> [-Session <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Create new credential group (folder) from Pleasant Password Server
    

PARAMETERS
    -Group <PSObject>
        Object contining group info
        
    -ParentId <Guid>
        ID of parent group
        
    -Name <String>
        Name of the new group (folder)
        
    -Session <String>
        Makes it possible to connect to multiple Pleasant Password Servers
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>New-PpsGroup -ParentId f6190167-a9a1-4386-a8cd-ae46008c9188 -Name "New Password Group"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-PpsGroup -examples".
    For more information, type: "get-help New-PpsGroup -detailed".
    For technical information, type: "get-help New-PpsGroup -full".

```

<a name="Update-PpsEntry"></a>
### Update-PpsEntry

```
NAME
    Update-PpsEntry
    
SYNOPSIS
    Update existing credential entry in Pleasant Password Server
    
    
SYNTAX
    Update-PpsEntry [-Entry] <PSObject> [[-Session] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Update existing credential entry in Pleasant Password Server
    

PARAMETERS
    -Entry <PSObject>
        Object with updated info
        
    -Session <String>
        Makes it possible to connect to multiple Pleasant Password Servers
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$e=Get-PpsEntry -Id c079a48c-a465-4605-9477-2b4baa743e6f; $e.Username='user'; $e|Update-PpsEntry
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Update-PpsEntry -examples".
    For more information, type: "get-help Update-PpsEntry -detailed".
    For technical information, type: "get-help Update-PpsEntry -full".

```



