function out-of-top5 {
    $count = 0;
    $index = [byte][char]$args[0]
    for($i=0; $i -lt $index; $i++) {
        if ($letters[$i] -ge $letters[$index]) {
            $count++
        }
    }
    for($i=$index+1; $i -le 255; $i++) {
        if ($letters[$i] -gt $letters[$index]) {
            $count++
        }
    }
    if ($count -gt 4){$TRUE}
    else {$FALSE}
}

$sum = 0

$letters = @()

# yeah yeah, 256 is probably unnecessary, but it's easy
for($i=0; $i -le 255; $i++){
    $letters += 0
}

Remove-Item '.\trimmed'

$lines = Get-Content input

foreach ($line in $lines){
    # clear out the letter counts
    for($i=0; $i -le 255; $i++){
        $letters[$i] = 0
    }

    $fields = @($line.Trim() -split '-')
    foreach ($field in $fields) {
        if ($field.Contains('[')) {
            $tail = @($field -split '\[')
            foreach ($letter in $tail[1].ToCharArray()){
                if ($letter -eq ']') {
                    $sum = $sum + $tail[0]
                    Add-Content ".\trimmed" $line
                    break
                }
                else {
                    if (out-of-top5 $letter) {
                        break
                    }
                }
            }
        }
        else {
            foreach ($char in $field.ToCharArray()) {
                $letters[[byte][char]$char]++;
            }
        }
    }
}

Write-Host $sum


