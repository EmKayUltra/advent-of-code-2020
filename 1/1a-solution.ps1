$inputs = get-content "input.txt"

$inputs | % {$i = 0} { $entry1 = [int]$_; $inputs[$i..$inputs.Length] | % { $entry2 = [int]$_; if (($entry1+$entry2) -eq 2020) { echo "$($entry1*$entry2)"; exit; } }  }