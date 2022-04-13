function New-PpsGroup
{
    <#
        .SYNOPSIS
            Create new credential group (folder) from Pleasant Password Server

        .DESCRIPTION
            Create new credential group (folder) from Pleasant Password Server

        .PARAMETER Group
            Object contining group info

        .PARAMETER ParentId
            ID of parent group

        .PARAMETER Name
            Name of the new group (folder)

        .PARAMETER Session
            Makes it possible to connect to multiple Pleasant Password Servers

        .EXAMPLE
            New-PpsGroup -ParentId f6190167-a9a1-4386-a8cd-ae46008c9188 -Name "New Password Group"
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ParameterSetName='Group')]
        [PSCustomObject]
        $Group,

        [Parameter(Mandatory=$true, ParameterSetName='Properties')]
        [guid]
        $ParentId,

        [Parameter(Mandatory=$true, ParameterSetName='Properties')]
        [string]
        $Name,

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

            if (-not $Group)
            {
                $Group = [PSCustomObject] @{
                    ParentId = $ParentId
                    Name     = $Name
                }
            }

            $id = Invoke-PpsApiRequest @p -Uri "credentialgroup" -Data $Group -Method Post

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