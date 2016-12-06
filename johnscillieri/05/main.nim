import future
import md5
import random
import sequtils
import strutils

proc sixth_character( s: string ): string =
    # Return the valid character else an empty string
    let hash = getMD5( s )
    if hash.startswith("00000"): $hash[5] else: ""

template random_letter(): string =
    $random( "abcdefghijklmnopqrstuvwxyz" )

template random_string( length: int ): string =
    join( lc[ random_letter() | ( _ <- 0..<length ), string ] )

proc main() =
    let base = "ffykfhsq"
    var result = ""

    var index = 0
    while result.len < 8:
        let character = sixth_character( base & $index )
        index += 1
        if character != "":
            result &= character
        if index mod 100000 == 0:
            stdout.write( "Password: " & result & random_string( 8 - len(result) ) & "\r" )
            stdout.flushFile
    echo( "Password: " & result )
    echo "\nDone."

when isMainModule:
    main()
