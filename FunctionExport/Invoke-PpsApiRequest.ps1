function Invoke-PpsApiRequest
{
    <#
        .SYNOPSIS
            Invoke API request against Pleasant Password Server

        .DESCRIPTION
            Invoke API request against Pleasant Password Server

        .PARAMETER Uri
            xxx

        .PARAMETER Method
            xxx

        .PARAMETER Data
            xxx

        .PARAMETER Session
            Makes it possible to connect to multiple Pleasant Password Servers

        .EXAMPLE
            xxx
    #>

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Uri,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method = 'Get',

        [Parameter()]
        [object]
        $Data,

        [Parameter()]
        [string]
        $Session = 'Default'
    )

    begin
    {
        Write-Verbose -Message "Begin (ErrorActionPreference: $ErrorActionPreference)"
        $origErrorActionPreference = $ErrorActionPreference
        $verbose = $PSBoundParameters.ContainsKey('Verbose') -or ($VerbosePreference -ne 'SilentlyContinue')

        # FIXXXME - should this be moved out - so it is run when module is imported?
        if (-not $script:SessionList)
        {
            Write-Verbose -Message 'Creating session list'
            $script:SessionList = @{}
        }
    }

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"

        try
        {
            # Make sure that we don't continue on error, and that we catches the error
            $ErrorActionPreference = 'Stop'

            if (-not ($s = $script:SessionList[$Session]))
            {
                throw "Session <$Session> not found"
            }

            $requestParams = @{
                Method          = $Method
                Uri             = "$($s.Uri)/api/v4/rest/$Uri"  # FIXXXME - v4 should'n be hardcoded here!
                Headers         = $s.Headers
                UseBasicParsing = $true
            }
            if ($Data)
            {
                $requestParams['Body']        = ConvertTo-Json -Compress -Depth 9 -InputObject $Data
                $requestParams['ContentType'] = 'application/json; charset=utf-8'
            }

            Write-Verbose -Message ($requestParams | ConvertTo-Json)

            # Return
            Invoke-RestMethod @requestParams
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