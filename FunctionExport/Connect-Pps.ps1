function Connect-Pps
{
    <#
        .SYNOPSIS
            Connect to Pleasant Password Server

        .DESCRIPTION
            Connect to Pleasant Password Server

        .PARAMETER Uri
            URI of server to connect to, eg. https://password.company.tld:10001

        .PARAMETER Credential
            Credential object with username and password used to connect to Pleasant Password Server with

        .PARAMETER Username
            Username used to connect to Pleasant Password Server with

        .PARAMETER Password
            Password used to connect to Pleasant Password Server with

        .PARAMETER Session
            Makes it possible to connect to multiple Pleasant Password Servers

        .EXAMPLE
            Connect-Pps -Uri https://password.company.tld:10001
    #>

    [CmdletBinding(DefaultParameterSetName='Default')]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $Uri,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='Credential')]
        [pscredential]
        $Credential,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='UserPass')]
        [string]
        $Username,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='UserPass')]
        [string]
        $Password,

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

            if ($Uri -notmatch ':') {$Uri = "https://${Uri}:10001"}
            $Uri = $Uri -replace '/$'

            if (-not ($Credential -or $Username -or $Password))
            {
                $PSBoundParameters['Credential'] = Get-Credential -Message 'PPS'
            }


            $oauth2Params = @{
                Uri          = "$Uri/OAuth2/Token"
                ReturnHeader = $true
            }
            $PSBoundParameters.GetEnumerator() | Where-Object -Property Key -In -Value 'Credential','Username','Password' | ForEach-Object -Process {
                $oauth2Params[$_.Key] = $_.Value
            }

            $script:SessionList[$Session] = [PSCustomObject] @{
                Uri     = $Uri
                Headers = Connect-OAuth2 @oauth2Params
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
