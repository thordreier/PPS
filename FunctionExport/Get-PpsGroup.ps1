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
            Get-PpsGroup -Id f6190167-a9a1-4386-a8cd-ae46008c9188

        .EXAMPLE
            Get-PpsGroup -All
    #>

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(ParameterSetName='All', Mandatory=$true)]
        [switch]
        $All,

        [Parameter(ParameterSetName='Id', Mandatory=$true, Position=0)]
        [guid]
        $Id,

        [Parameter(ParameterSetName='Path', Mandatory=$true, Position=0)]
        [string]
        $Path,

        [Parameter(ParameterSetName='Path')]
        [switch]
        $ReturnId,

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
        if (-not $script:GroupCache)
        {
            Write-Verbose -Message 'Creating group cache'
            $script:GroupCache = @{}
        }
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

            $uri = 'credentialgroup'

            if ($Path)
            {
                if ($script:GroupCache.ContainsKey($Path))
                {
                    $Id = $script:GroupCache[$Path]
                }
                elseif ($Path -ceq 'Root')
                {
                    $script:GroupCache[$Path] = $Id = Invoke-PpsApiRequest @p -Uri "$uri/root"
                }
                elseif ($Path -notmatch '/')
                {
                    throw "First part of path should always be Root, not $Path"
                }
                else
                {
                    $parentPath, $name = $Path -split '/(?=[^/]*$)'
                    $parent = Get-PpsGroup @p -Path $parentPath
                    try
                    {
                        $script:GroupCache[$Path] = $Id = $parent.Children | Where-Object -Property Name -EQ -Value $Name | Select-Object -First 1 -ExpandProperty Id
                    }
                    catch
                    {
                        throw "Group path $Path not found"
                    }
                }
            }

            if ($Id)
            {
                $uri = "$uri/$Id"
            }

            # Return
            if ($ReturnId)
            {
                $Id
            }
            else
            {
                Invoke-PpsApiRequest @p -Uri $uri
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