function New-PpsEntry
{
    <#

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