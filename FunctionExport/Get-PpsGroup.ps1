function Get-PpsGroup
{
    <#
        .SYNOPSIS
            Get credential group (folder) from Pleasant Password Server

        .DESCRIPTION
            Get credential group (folder) from Pleasant Password Server

        .PARAMETER Id
            ID of group to get info about

        .PARAMETER Session
            Makes it possible to connect to multiple Pleasant Password Servers

        .EXAMPLE
            Get-PpsGroup

        .EXAMPLE
            Get-PpsGroup -Id f6190167-a9a1-4386-a8cd-ae46008c9188
    #>

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Position=0)]
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

            $folder          = Invoke-PpsApiRequest @p -Uri "credentialgroup/$Id"

            # Return
            $folder
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