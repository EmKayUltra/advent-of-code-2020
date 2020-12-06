param ($dayNumber)

mkdir $dayNumber | out-null
cd $dayNumber | out-null
ni "input.txt" | out-null
ni "$($dayNumber)a-solution.ps1" | out-null
echo "[CmdletBinding()]`nparam()`n`$inputs = get-content `"input.txt`"" > "$($dayNumber)a-solution.ps1"
ni "$($dayNumber)a-problem.md" | out-null
ni "$($dayNumber)b-solution.ps1" | out-null
echo "[CmdletBinding()]`nparam()`n`$inputs = get-content `"input.txt`"" > "$($dayNumber)b-solution.ps1"
ni "$($dayNumber)b-problem.md" | out-null
cls
write-host "a new day" -foregroundcolor green -nonewline
write-host " has begun!" -foregroundcolor red