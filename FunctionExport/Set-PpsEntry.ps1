function Set-PpsEntry
{
    <#
        .SYNOPSIS
            Update existing credential entry in Pleasant Password Server

        .DESCRIPTION
            Update existing credential entry in Pleasant Password Server

        .PARAMETER Entry
            Object with updated info

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
            $e=Get-PpsEntry -Id c079a48c-a465-4605-9477-2b4baa743e6f; $e.Username='user'; $e|Set-PpsEntry
    #>

    [CmdletBinding(DefaultParameterSetName='Properties')]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [PSCustomObject]
        $Entry,

        [Parameter(ParameterSetName='Properties')]
        [Parameter(ParameterSetName='PSCredential')]
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

        [Parameter(ParameterSetName='PSCredential', Mandatory=$true)]
        [PSCredential]
        $PSCredential,

        [Parameter(ParameterSetName='Properties')]
        [Parameter(ParameterSetName='PSCredential')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $Url,

        [Parameter(ParameterSetName='Properties')]
        [Parameter(ParameterSetName='PSCredential')]
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

            if ($PSCredential)
            {
                $PSBoundParameters['Username'] = $PSCredential.UserName
                $PSBoundParameters['Password'] = $PSCredential.GetNetworkCredential().Password
            }

            'Name', 'Username', 'Password', 'Url', 'Notes' | ForEach-Object -Process {
                if ($PSBoundParameters.ContainsKey($_))
                {
                    $Entry.$_ = $PSBoundParameters[$_]
                }
            }

            $id = $Entry.Id
            $null = Invoke-PpsApiRequest @p -Uri "credential/$($Entry.Id)" -Data $Entry -Method Put

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
