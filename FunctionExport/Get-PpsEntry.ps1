function Get-PpsEntry
{
    <#
        .SYNOPSIS
            Get credential entry from Pleasant Password Server

        .DESCRIPTION
            Get credential entry from Pleasant Password Server

        .PARAMETER Id
            ID of entry to get info about

        .PARAMETER Path
            xxx

        .PARAMETER Name
            xxx

        .PARAMETER AllowMultiple
            xxx

        .PARAMETER PSCredential
            xxx

        .PARAMETER Session
            Makes it possible to connect to multiple Pleasant Password Servers

        .EXAMPLE
            Get-PpsEntry -Id 5cbfabe7-70ee-4041-a1e0-263c9170f650
    #>

    [CmdletBinding(DefaultParameterSetName='Id')]
    [OutputType([PSCustomObject], ParameterSetName='Id')]
    [OutputType([PSCustomObject], ParameterSetName='Path')]
    [OutputType([PSCredential], ParameterSetName='IdCred')]
    [OutputType([PSCredential], ParameterSetName='PathCred')]
    param
    (
        [Parameter(ParameterSetName='Id', Mandatory=$true, Position=0)]
        [Parameter(ParameterSetName='IdCred', Mandatory=$true, Position=0)]
        [Parameter(ParameterSetName='IdPw', Mandatory=$true, Position=0)]
        [guid]
        $Id,

        [Parameter(ParameterSetName='Path', Mandatory=$true)]
        [Parameter(ParameterSetName='PathCred', Mandatory=$true)]
        [string]
        $Path,

        [Parameter(ParameterSetName='Path')]
        [Parameter(ParameterSetName='PathCred')]
        [string]
        $Name,

        [Parameter(ParameterSetName='Path')]
        [Parameter(ParameterSetName='PathCred')]
        [switch]
        $AllowMultiple,

        [Parameter(ParameterSetName='IdCred', Mandatory=$true)]
        [Parameter(ParameterSetName='PathCred', Mandatory=$true)]
        [switch]
        $PSCredential,

        [Parameter(ParameterSetName='IdPw', Mandatory=$true)]
        [switch]
        $PasswordOnly,

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

            if ($PasswordOnly -and $Id)
            {
                $entry = @([PSCustomObject] @{Id = $Id; Password = ''})
            }
            elseif ($Id)
            {
                $entry = @(Invoke-PpsApiRequest @p -Uri "credential/$Id")
            }
            elseif ($Path)
            {
                $group = Get-PpsGroup @p -Path $Path
                $entry = @($group.Credentials)
                if ($Name)
                {
                    $entry = @($entry | Where-Object -Property Name -Like -Value $Name)
                }
                if ($entry.Count -gt 1 -and -not $AllowMultiple)
                {
                    throw "More than one ($($entry.Count)) entries returned and -AllowMultiple is not set"
                }
            }
            else
            {
                throw 'Should never happen'
            }

            foreach ($e in $entry)
            {
                $e.Password = Invoke-PpsApiRequest @p -Uri "credential/$($e.Id)/password"
            }

            # Return
            if ($PSCredential)
            {
                foreach ($e in $entry)
                {
                    [pscredential]::new($e.Username, ($e.Password | ConvertTo-SecureString -AsPlainText -Force))
                }
            }
            elseif ($PasswordOnly)
            {
                foreach ($e in $entry)
                {
                    $e.Password
                }
            }
            else
            {
                $entry
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