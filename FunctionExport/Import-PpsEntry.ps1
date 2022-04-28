function Import-PpsEntry
{
    <#
        .SYNOPSIS
            xxx

        .DESCRIPTION
            xxx

        .PARAMETER RootPath
            xxx

        .PARAMETER InputObject
            xxx

        .PARAMETER NoCheck
            xxx

        .PARAMETER CheckProperty
            xxx

        .PARAMETER Session
            Makes it possible to connect to multiple Pleasant Password Servers

        .EXAMPLE
            xxx

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

        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [PSCustomObject]
        $InputObject,

        [Parameter()]
        [switch]
        $NoCheck,

        [Parameter()]
        [string[]]
        $CheckProperty = @('Name', 'Username'),

        [Parameter()]
        [string]
        $Session = 'Default'
    )

    begin
    {
        Write-Verbose -Message "Begin (ErrorActionPreference: $ErrorActionPreference)"
        $origErrorActionPreference = $ErrorActionPreference
        $verbose = $PSBoundParameters.ContainsKey('Verbose') -or ($VerbosePreference -ne 'SilentlyContinue')

        $allProperties = @('Name', 'Username', 'Password', 'Url', 'Notes')

        if (-not $NoCheck)
        {
            # Some versions of PowerShell doesn't seem to trigger ValidateScript on an empty array. That's why it's located here
            if (-not $CheckProperty.Count) {throw 'CheckProperty should not be empty'}
            $CheckProperty | ForEach-Object -Process {if ($_ -notin $allProperties) {throw "$_ is not allowed in CheckProperty, only $($allProperties -join ',') is allowed"}}
            $CheckProperty = @('Path') + $CheckProperty

            $existing = Export-PpsEntry -RootPath $RootPath -WithId
            $existingHash = $existing | Group-Object -Property $CheckProperty -AsHashTable -AsString
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

            $fullPath = if ($InputObject.Path) {$RootPath + '/' + $InputObject.Path} else {$RootPath}

            $entryParams = @{}
            $allProperties | ForEach-Object -Process {
                $entryParams[$_] = $InputObject.$_
            }

            if ($NoCheck)
            {
                $null = New-PpsEntry @p -Path $fullPath @entryParams
            }
            else
            {
                $key = ($InputObject | Group-Object -Property $CheckProperty -AsHashTable -AsString).Keys | Select-Object -First 1
                if ($e = @($existingHash[$key] | Where-Object -FilterScript {-not $_._PROCESSED_}))
                {
                    if ($e.Count -gt 1) {Write-Warning -Message "Found $($e.Count) objects matching ""$key"", just selecting first match"}
                    $e = $e[0]
                    $e | Add-Member -NotePropertyName _PROCESSED_ -NotePropertyValue $true
                    if (Compare-Object -ReferenceObject $e -DifferenceObject $InputObject -Property $allProperties)
                    {
                        "Updating $key" | Write-Host
                        $null = Get-PpsEntry @p -Id $e.Id | Set-PpsEntry @p @entryParams
                    }
                    else
                    {
                        "OK $key" | Write-Host
                    }
                }
                else
                {
                    "Creating $key" | Write-Host
                    $null = New-PpsEntry @p -Path $fullPath @entryParams

                }
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
        # Not processed
        #$existing | Where-Object -FilterScript {-not $_._PROCESSED_}

        Write-Verbose -Message 'End'
    }
}