$inputs = get-content "input.txt"
$sceneWidth = $inputs[0].Length
$sceneHeight = $inputs.Length

$OPEN = "."
$TREE = "#"

$curX, $curY = 0,0

$numTrees = 0

do {
    if ($inputs[$curY][$curX % $sceneWidth] -eq $TREE) {
        $numTrees++
    }
    $curX+=3
    $curY++
} while ($curY -lt $sceneHeight)

write-host "$numTrees trees"