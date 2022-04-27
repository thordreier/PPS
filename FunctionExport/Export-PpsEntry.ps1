function Export-PpsEntry
{
    <#
        .SYNOPSIS
            xxx

        .DESCRIPTION
            xxx

        .PARAMETER RootPath
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
        [string]
        $Session = 'Default'
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
                    Path     = $Path -join '/'
                    Name     = $_.Name
                    Username = $_.UserName
                    Password = Get-PpsEntry -Id $_.Id -PasswordOnly
                    Url      = $_.Url
                    Notes    = $_.Notes
                }
            }
            $group.Children | ForEach-Object -Process {
                GetGrp -GroupId $_.Id -Path ($Path + $_.Name)
            }
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
            GetGrp -GroupId $groupId
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