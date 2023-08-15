function InfoOut
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)] [String] $Message,
        [Parameter()] [switch] $Quiet
    )

    begin
    {}

    process
    {
        if (-not $Quiet)
        {
            $Message | Write-Host
        }
    }

    end
    {}
}
