[CmdletBinding()]
param()
$inputs = get-content "input.txt"

$ALL_FIELDS = @("byr","iyr","eyr","hgt","hcl","ecl","pid","cid")
$REQUIRED_FIELDS = $ALL_FIELDS | ? { $_ -ne "cid" }

function validate-passportstring($passport) {
    write-verbose "validating passport: $passport"
    $passportFields = $passport -split " "
    $providedKeys = $passportFields | % {
        $key,$val = $_ -split ":"
        if ($val -ne "") {
            return $key
        }
    }

    write-verbose "keys found: $providedKeys"

    $missingFields = $REQUIRED_FIELDS | ? { !($providedKeys.Contains($_)) }

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