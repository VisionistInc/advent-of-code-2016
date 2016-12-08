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

proc is_within_from_offset( pattern: string, s: char, e: char, source: string, offset: int ): bool =
    ## Just check that pattern is between s & e in source from the given offset
    var offset = source.find( pattern, offset )
    if offset == -1: return false

    let prev_start = source.rfind( s, offset )
    let prev_end = source.rfind( e, offset )
    let later_start = source.find( s, offset )
    let later_end = source.find( e, offset )

    let is_after_open = prev_start > prev_end or ( prev_end == -1 and prev_start != -1 )
    let is_before_end = later_end < later_start or ( later_start == -1 and later_end != -1 )
    return is_after_open and is_before_end

proc is_within( pattern: string, s: char, e: char, source: string ): bool =
    ## Check that pattern is between s & e anywhere in source
    result = false
    var offset = source.find( pattern, 0 )
    while offset != -1:
        if pattern.is_within_from_offset( s, e, source, offset ): return true
        offset = source.find( pattern, offset+len(pattern) )

proc supports_ssl( s: string ): bool =
    result = false
    for i in 0..<(len(s)-2):
        if s[i] != s[i+2] or s[i] == s[i+1]: continue

        let pattern = s[i] & s[i+1] & s[i]
        let inverse = s[i+1] & s[i] & s[i+1]
        if inverse.is_within( '[', ']', s ) and not pattern.is_within_from_offset( '[', ']', s, i ):
            return true

let data = toSeq( lines( "input.txt" ) )
echo "Part 1 result: ", len( filterIt( data, is_valid_ip( it ) ) )
echo "Part 2 result: ", len( filterIt( data, supports_ssl( it ) ) )
