$inputs = get-content "input.txt"

$inputs | % {$i = 0} { 
    $entry1 = [int]$_; 
    $inputs[$i..$inputs.Length] | % {$j = 0} { 
        $entry2 = [int]$_; 
        if (($entry1+$entry2) -lt 2020) { 
            $inputs[$j..$inputs.Length] | % {
                $entry3 = [int]$_; 
                if ($entry1+$entry2+$entry3 -eq 2020) {
                    echo "$($entry1*$entry2*$entry3)"
                    exit; 
                }
            }
        }
    }  
}