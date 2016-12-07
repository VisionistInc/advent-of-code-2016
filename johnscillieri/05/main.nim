import future
import md5
import random
import sequtils
import strutils
import os

proc position_and_character( s: string ): tuple[position: int, character: char] =
    # Return the valid character else an empty string
    let hash = getMD5( s )
    if hash.startswith("00000") and hash[5] in {'0'..'7'}:
        result = (parseInt($hash[5]), hash[6])
    else:
        result = (-1, 'x')

template random_letter(): string =
    $random( "abcdefghijklmnopqrstuvwxyz" )

proc movie_string[T]( letters: openarray[T] ): string =
    result = ""
    for letter in items( letters ):
        result &= (if letter == '\0': random_letter() else: $letter)

proc main() =
    let base = "ffykfhsq"
    var result = newString(8)

    var index = 0
    while '\0' in result:
        let (position, character) = position_and_character( base & $index )
        index += 1
        if position != -1 and result[position] == '\0':
            result[position] = character
        if index mod 100000 == 0:
            stdout.write( "Cracking password: " & movie_string(result) & "\r" )
            stdout.flushFile
    echo( "Cracking password: " & result )
    echo "\nDone."

when isMainModule:
    main()
