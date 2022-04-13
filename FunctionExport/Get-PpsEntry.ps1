function Get-PpsEntry
{
    <#
        .SYNOPSIS
            Get credential entry from Pleasant Password Server

        .DESCRIPTION
            Get credential entry from Pleasant Password Server

        .PARAMETER Id
            ID of entry to get info about

        .PARAMETER Session
            Makes it possible to connect to multiple Pleasant Password Servers

        .EXAMPLE
            Get-PpsEntry -Id 5cbfabe7-70ee-4041-a1e0-263c9170f650
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [guid]
        $Id,

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

            $entry          = Invoke-PpsApiRequest @p -Uri "credential/$Id"
            $entry.Password = Invoke-PpsApiRequest @p -Uri "credential/$Id/password"

            # Return
            $entry
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