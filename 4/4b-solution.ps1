[CmdletBinding()]
param()
$inputs = get-content "input.txt"

$ALL_FIELDS = @("byr","iyr","eyr","hgt","hcl","ecl","pid","cid")
$REQUIRED_FIELDS = $ALL_FIELDS | ? { $_ -ne "cid" }

$VALIDATION_RULES = @{
    "byr" = { param([string]$val) valid-range ([int]$val) 1920 2002 }
    "iyr" = { param([string]$val) valid-range ([int]$val) 2010 2020 }
    "eyr" = { param([string]$val) valid-range ([int]$val) 2020 2030 }
    "hgt" = { param([string]$val) if ($val.EndsWith("cm")) { [int]$num = $val -replace "cm",""; valid-range $num 150 193  } elseif ($val.EndsWith("in")) { [int]$num = $val -replace "in",""; valid-range $num 59 76 } else { $false } }
    "hcl" = { param([string]$val) $val -match "^#[0-9a-f]{6}$" }
    "ecl" = { param([string]$val) @("amb","blu","brn","gry","grn","hzl","oth").Contains($val) }
    "pid" = { param([string]$val) $val -match "^[0-9]{9}$" }
    "cid" = { $true }
}

function valid-range([int]$x, [int]$low, [int]$high) {
    $x -ge $low -and $x -le $high
}

function validate-passportstring($passport) {
# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.
    write-verbose "validating passport: $passport"
    $passportFields = $passport -split " "
    $providedKeys = $passportFields | % {
        $key,$val = $_ -split ":"
        write-verbose "validating $key : $val"
        if ($VALIDATION_RULES.Keys.Contains($key) -and $VALIDATION_RULES[$key].Invoke($val)) {
            return $key
        }
    }

    write-verbose "keys found: $providedKeys"

    $missingFields = $REQUIRED_FIELDS | ? { $providedKeys -eq $null -or !($providedKeys.Contains($_)) }

    write-verbose "MISSING FIELDS: $missingFields"
    
    return $missingFields.Count -eq 0
}

function get-passports($inputs) {
    $passports = @()
    $inputs | % {$curPassport = @() } {
        if ($_.Length -eq 0 -and $curPassport -ne @()) {
            $passports += $curPassport -join " "
            $curPassport = @()
        } 
        else {
            $curPassport += $_
        }
    }
    # flush last
    $passports += $curPassport -join " "

    return $passports
}

$passports = get-passports $inputs

write-host "$(($passports | ? { (validate-passportstring $_) } | Measure-Object).Count) valid passports."