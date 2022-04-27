function Set-PpsEntry
{
    <#
        .SYNOPSIS
            Update existing credential entry in Pleasant Password Server

        .DESCRIPTION
            Update existing credential entry in Pleasant Password Server

        .PARAMETER Entry
            Object with updated info

        .PARAMETER Session
            Makes it possible to connect to multiple Pleasant Password Servers

        .EXAMPLE
            $e=Get-PpsEntry -Id c079a48c-a465-4605-9477-2b4baa743e6f; $e.Username='user'; $e|Set-PpsEntry
    #>

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [PSCustomObject]
        $Entry,

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