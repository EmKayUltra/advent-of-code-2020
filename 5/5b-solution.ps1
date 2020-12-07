[CmdletBinding()]
param()
$inputs = get-content "input.txt"

$MIN_ROW = 0
$MAX_ROW = 127
$MIN_COL = 0
$MAX_COL = 7

function ceil([decimal]$n) { [Math]::Ceiling($n) }
function floor([decimal]$n) { [Math]::Floor($n) }

function mid([int]$min, [int]$max) { (floor (($max-$min)/2)) }
function bottomRange([int]$min, [int]$max) { @($min, ($min+(mid $min $max))) }
function topRange([int]$min, [int]$max) { @(($min+(mid $min $max)+1), $max) }

$occupiedSeats = $inputs | % {
    $rowSegment = $_.Substring(0, 7)
    $colSegment = $_.Substring(7)
    $curRowRange = @($MIN_ROW, $MAX_ROW)
    $curColRange = @($MIN_COL, $MAX_COL)
    $rowSegment.ToCharArray() | % { 
        write-verbose "$_ : ($($curRowRange[0]), $($curRowRange[1]))"
        switch($_) {
            "F" { $curRowRange = bottomRange @curRowRange }
            "B" { $curRowRange = topRange @curRowRange }
        }
    }

    $colSegment.ToCharArray() | % { 
        write-verbose "$_ : ($($curColRange[0]), $($curColRange[1]))"
        switch($_) {
            "L" { $curColRange = bottomRange @curColRange }
            "R" { $curColRange = topRange @curColRange }
        }
    }
    
    ($curRowRange[0]*8)+$curColRange[0]
} | Sort-Object

$firstSeat = $occupiedSeats | Select-Object -First 1
$lastSeat = $occupiedSeats | Sort-Object -Descending | Select-Object -First 1

@($firstSeat..$lastSeat) | ? { !($occupiedSeats.Contains($_)) }