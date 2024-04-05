function Export-PpsEntry
{
    <#
        .SYNOPSIS
            xxx

        .DESCRIPTION
            xxx

        .PARAMETER RootPath
            xxx

        .PARAMETER WithId
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
        $RootPath,

        [Parameter()]
        [switch]
        $WithId,

        [Parameter()]
        [switch]
        $NoPassword,

        [Parameter()]
        [string]
        $Session = 'Default',

        [Parameter()]
        [scriptblock]
        $FilterScript
    )

    begin
    {
        Write-Verbose -Message "Begin (ErrorActionPreference: $ErrorActionPreference)"
        $origErrorActionPreference = $ErrorActionPreference
        $verbose = $PSBoundParameters.ContainsKey('Verbose') -or ($VerbosePreference -ne 'SilentlyContinue')

        $p = @{
            Session = $Session
        }

        function GetGrp ([guid] $GroupId, [string[]] $Path = @())
        {
            $group = Get-PpsGroup @p -Id $GroupId
            $group.Credentials  | ForEach-Object -Process {
                [PSCustomObject] @{
                    Id       = $_.Id
                    Path     = $Path -join '/'
                    Name     = $_.Name
                    Username = $_.UserName
                    Password = ''
                    Url      = $_.Url
                    Notes    = $_.Notes -replace "`r`n","`n"
                }
            }
            $group.Children | ForEach-Object -Process {
                GetGrp -GroupId $_.Id -Path ($Path + $_.Name)
            }
        }
        if (-not $FilterScript)
        {
            $FilterScript = {$true}
        }
        $excludeProperty = @()
        if (-not $WithId)
        {
            $excludeProperty += 'Id'
        }
    }

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"

        try
        {
            # Make sure that we don't continue on error, and that we catches the error
            $ErrorActionPreference = 'Stop'

            $groupId = Get-PpsGroup @p -Path $RootPath -ReturnId
            GetGrp -GroupId $groupId | Where-Object -FilterScript $FilterScript | ForEach-Object -Process {
                if (-not $NoPassword) {$_.Password = Get-PpsEntry @p -Id $_.Id -PasswordOnly}
                $_
            } | Select-Object -Property * -ExcludeProperty $excludeProperty
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
