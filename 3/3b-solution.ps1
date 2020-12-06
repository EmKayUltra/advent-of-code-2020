[CmdletBinding()]
param()

$inputs = get-content "input.txt"
[int64]$sceneWidth = $inputs[0].Length
[int64]$sceneHeight = $inputs.Length

$OPEN = "."
$TREE = "#"
$SLOPES = @("1,1","3,1","5,1","7,1","1,2")

function get-numtreesforslope($right, $down) {
    write-verbose "finding numTrees for slope `($right, $down`)"

    $curX, $curY = 0,0

    $numTrees = 0

    do {
        write-verbose "processing $curX,$curY"
        if ($inputs[$curY][$curX % $sceneWidth] -eq $TREE) {
            $numTrees++
        }
        $curX+=$right
        $curY+=$down
    } while ($curY -lt $sceneHeight)

    write-verbose "$numTrees found for slope `($right, $down`)`n"
    return $numTrees
}


$SLOPES | % {[int64]$treeAccumulator = 1 } { $right,$down = $_.Split(","); $treeAccumulator *= get-numtreesforslope $right $down }

write-host "$treeAccumulator"

