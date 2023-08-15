function New-PpsEntry
{
    <#
        .SYNOPSIS
            Create new credential entry in Pleasant Password Server

        .DESCRIPTION
            Create new credential entry in Pleasant Password Server

        .PARAMETER Entry
            Object with data to create in Pleasant Password Server

        .PARAMETER GroupId
            ID of credential group to create credential entry in

        .PARAMETER Name
            Name of credential in Pleasant Password Server

        .PARAMETER Username
            Username of credential in Pleasant Password Server

        .PARAMETER Password
            Password of credential in Pleasant Password Server

        .PARAMETER PSCredential
            xxx

        .PARAMETER Url
            Url of credential in Pleasant Password Server

        .PARAMETER Notes
            Notes of credential in Pleasant Password Server

        .PARAMETER Session
            Makes it possible to connect to multiple Pleasant Password Servers

        .EXAMPLE
            New-PpsEntry -GroupId f6190167-a9a1-4386-a8cd-ae46008c9188 -Name name -Username uname -Password pw -Url http://abc -Notes "This i a note"

        .EXAMPLE
            @{GroupId='f6190167-a9a1-4386-a8cd-ae46008c9188'; Name='name'; Username='user'; Password='pw'} | New-PpsEntry
    #>

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(ParameterSetName='Entry', Mandatory=$true, ValueFromPipeline=$true)]
        [PSCustomObject]
        $Entry,

        [Parameter(ParameterSetName='Properties', Mandatory=$true)]
        [Parameter(ParameterSetName='PSCredential', Mandatory=$true)]
        [guid]
        $GroupId,

        [Parameter(ParameterSetName='PropertiesPath', Mandatory=$true)]
        [Parameter(ParameterSetName='PSCredentialPath', Mandatory=$true)]
        [string]
        $Path,

        [Parameter(ParameterSetName='Properties')]
        [Parameter(ParameterSetName='PSCredential')]
        [Parameter(ParameterSetName='PropertiesPath')]
        [Parameter(ParameterSetName='PSCredentialPath')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Name,

        [Parameter(ParameterSetName='Properties')]
        [Parameter(ParameterSetName='PropertiesPath')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Username,

        [Parameter(ParameterSetName='Properties')]
        [Parameter(ParameterSetName='PropertiesPath')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Password,

        [Parameter(ParameterSetName='PSCredential', Mandatory=$true)]
        [Parameter(ParameterSetName='PSCredentialPath', Mandatory=$true)]
        [PSCredential]
        $PSCredential,

        [Parameter(ParameterSetName='Properties')]
        [Parameter(ParameterSetName='PSCredential')]
        [Parameter(ParameterSetName='PropertiesPath')]
        [Parameter(ParameterSetName='PSCredentialPath')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Url,

        [Parameter(ParameterSetName='Properties')]
        [Parameter(ParameterSetName='PSCredential')]
        [Parameter(ParameterSetName='PropertiesPath')]
        [Parameter(ParameterSetName='PSCredentialPath')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Notes,

        [Parameter()]
        [string]
        $Session = 'Default'
    )

    begin
    {
        Write-Verbose -Message "Begin (ErrorActionPreference: $ErrorActionPreference)"
        $origErrorActionPreference = $ErrorActionPreference
        $verbose = $PSBoundParameters.ContainsKey('Verbose') -or ($VerbosePreference -ne 'SilentlyContinue')
    }

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"

        try
        {
            # Make sure that we don't continue on error, and that we catches the error
            $ErrorActionPreference = 'Stop'

            $p = @{
                Session = $Session
            }

            if (-not $Entry)
            {
                if ($PSCredential)
                {
                    $Username = $PSCredential.UserName
                    $Password = $PSCredential.GetNetworkCredential().Password
                }

                if ($Path)
                {
                    $GroupId = New-PpsGroup @p -Path $Path -ReturnId
                }

                $Entry = [PSCustomObject] @{
                    GroupId  = $GroupId
                    Name     = $Name
                    Username = $Username
                    Password = $Password
                    Url      = $Url
                    Notes    = $Notes
                }
            }

            $id = Invoke-PpsApiRequest @p -Uri "credential" -Data $Entry -Method Post

            # Return
            [PSCustomObject] @{
                Id  = $id
                Uri = "$($script:SessionList[$Session].Uri)/WebClient/Main?itemId=$id"
            }
        }
        catch
        {
            Write-Verbose -Message "Encountered an error: $_"
            Write-Error -ErrorAction $origErrorActionPreference -Exception $_.Exception
        }
        finally
        {
            $ErrorActionPreference = $origErrorActionPreference
        }

        Write-Verbose -Message 'Process end'
    }

    end
    {
        Write-Verbose -Message 'End'
    }
}
