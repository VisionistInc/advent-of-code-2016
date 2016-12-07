import sequtils
import strutils

proc is_valid_ip( s: string ): bool =
    result = false
    for i in 0..<(len(s)-3):
        if s[i] == s[i+3] and s[i+1] == s[i+2] and s[i] != s[i+1]:
            if ( s.find('[', i) < s.find(']', i) and s.find('[', i) != -1 ) or ( s.find('[', i) == s.find(']', i) ):
                result = true
            else:
                return false
    return result

echo "Part 1: ", len( filterIt( toSeq(lines( "input.txt" )), is_valid_ip( it ) ) )
