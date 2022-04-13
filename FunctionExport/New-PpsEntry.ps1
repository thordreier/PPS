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
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ParameterSetName='Entry')]
        [PSCustomObject]
        $Entry,

        [Parameter(Mandatory=$true, ParameterSetName='Properties')]
        [guid]
        $GroupId,

        [Parameter(ParameterSetName='Properties')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Name,

        [Parameter(ParameterSetName='Properties')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Username,

        [Parameter(ParameterSetName='Properties')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Password,

        [Parameter(ParameterSetName='Properties')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Url,

        [Parameter(ParameterSetName='Properties')]
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