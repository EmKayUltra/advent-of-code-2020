[CmdletBinding()]
param()
$inputs = get-content "input.txt"

function countInstancesOfCharInString([string]$str, [string]$c) { ($str.ToCharArray() | ? { $_ -eq $c } | measure).Count }
function get-groupsWithIndividuals($inputs) {
    $groups = @()
    $inputs | % {$curGroup = @() } {
        if ($_.Length -eq 0 -and $curGroup -ne @()) {
            $groups += ,$curGroup # "," prefix forces adding the array as an element rather than doing an addrange
            $curGroup = @()
        } 
        else {
            $curGroup += $_
        }
    }
    # flush last
    $groups += ,$curGroup

    return $groups
}

$groups = get-groupsWithIndividuals $inputs

# just find those instances where the # of times the character occurs is equal to the number of individuals
($groups | % {$i=0} { 
    $currentGroup = $_

    Write-Verbose "Processing group"
    Write-Verbose "Group size: $($groups[$i].Length)"
    $currentGroup | % { Write-Verbose $_ }

    $answersConcatenated = $_ -join ""
    $questionsAnsweredYesByAll = ($answersConcatenated.ToCharArray() 
    | select -unique 
    | ? { (countInstancesOfCharInString $answersConcatenated $_) -eq $currentGroup.Length }) -join ""
    
    Write-Verbose "Answered by all: $questionsAnsweredYesByAll ($($questionsAnsweredYesByAll.Length))"

    return $questionsAnsweredYesByAll.Length
} | measure -sum).Sum
