[CmdletBinding()]
param()
$inputs = get-content "input.txt"
$validPasswords = 0

$inputs | % {
    $entry = $_     
    $rule,$password = $_ -split ": "
    $range,$letter = $rule -split " "
    [int]$min,[int]$max = $range -split "-"
    
    $occurrences = ($password.ToCharArray() -eq $letter).Count

    if ($occurrences -le $max -and $occurrences -ge $min) {
        $validPasswords += 1
    }
}

write-host "$validPasswords valid passwords"