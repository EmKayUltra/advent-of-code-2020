[CmdletBinding()]
param()
$inputs = get-content "input.txt"

function get-groups($inputs) {
    $groups = @()
    $inputs | % {$curGroup = @() } {
        if ($_.Length -eq 0 -and $curGroup -ne @()) {
            $groups += $curGroup -join ""
            $curGroup = @()
        } 
        else {
            $curGroup += $_.ToCharArray()
        }
    }
    # flush last
    $groups += $curGroup -join ""

    return $groups
}

$groups = get-groups $inputs 

($groups | % { $_.ToCharArray() | select -Unique | measure | select Count } 
| measure -Sum Count).Sum