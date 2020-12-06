[CmdletBinding()]
param()
$inputs = get-content "input.txt"
$validPasswords = 0

$inputs | % {
    $entry = $_     
    $rule,$password = $_ -split ": "
    $range,$letter = $rule -split " "
    [int]$min,[int]$max = $range -split "-"
    
    if (($password[$min-1] -eq $letter -and $password[$max-1] -ne $letter) -or
            ($password[$max-1] -eq $letter -and $password[$min-1] -ne $letter)) {
        $validPasswords += 1
    }
}

write-host "$validPasswords valid passwords"