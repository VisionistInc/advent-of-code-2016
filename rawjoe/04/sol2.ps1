Invoke-Expression -Command ".\sol1.ps1"

$lines = Get-Content trimmed

foreach ($line in $lines) {
    $words = @()
    $fields = @($line.Trim() -split '-')
    foreach ($field in $fields) {
        if ($field.Contains('[')) {
            $tail = @($field -split '\[')
            $room = ""
            foreach ($word in $words) {
                foreach ($letter in $word.ToCharArray()){
                    $num = [byte][char]$letter + $tail[0]
                    while ($num -gt [byte][char]'z') {
                        $num = $num - 26
                    }
                    $room += [char][byte]$num
                }
                $room += ' '
            }
            if ($room.Contains('north')) {
                Write-Host $room $tail[0]
            }
        }
        else {
            $words += $field
        }
    }
}
