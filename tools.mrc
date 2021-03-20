alias dumpColorTable {

        ;; get table size from input, or default to 2.
        var %size       = $iif($1, $1, 2)
        var %i          = 0
        var %y          = 1
        ;; line length starts at 8 for the first 2 rows.
        ;; this is to print the default original 16 colours.
        var %lineLength = 8

        while (%y <= 9) {

                ;; clear lines to be printed
                var %line1
                var %line2

                var %x = 1

                while (%x <= %lineLength) {

                        ;; only construct the line containing pallette index values if the .values property is specified
                        if ($prop == values) {

                                var %line1 $+(%line1,) $+ 01, $+ %i $+ $+($str($chr(160), $calc((%size * 2) - 2))) $+ 00,01 $+ $numpad(%i, 2)
                        }

                        ;; construct the regular, value-less line.
                        var %line2 $+(%line2,) $+ 01, $+ %i $+ $+($str($chr(160), $calc(%size * 2)))

                        ;; increment pallette index and collumn count.
                        inc %i
                        inc %x
                }

                ;; when finished constructing the line(s), print them on screen.
                ;; as above, the one containing palette index values may be skipped.
                if ($prop == values) {

                        echo -s %line1
                }

                else {

                        echo -s %line2
                }

                ;; to account for size, repeat the value-less row a few times.
                var %j = 1

                while (%j < %size) {

                        echo -s %line2
                        inc %j
                }

                ;; increment row count
                inc %y

                ;; when we reach the 3rd row, change the line length to 12.
                ;; also print a blank line in between, for aesthetics.
                if (%y == 3) {

                        var %lineLength = 12
                        echo -s 
                }
        }

        ;; one last blank line.
        echo -s 
}

alias k {

        return  $+ $1 $+ $iif($2, $chr(44) $+ $2)
}

alias mError {

        var %input $1-

        ;; lookup tables for brackets and their colorised replacements
        var %bracketsPlain     < > $([) $(]) ' '
        var %bracketsColorised 64<76 64> 71[83 71] 96'97 96'

        ;; prefixes and their replacements
        var %prefixesPlain      / . :
        var %prefixesMod        65/77 56.80 :

        ;; replace prefixes. this requires some $gettok() magic.
        var %i 1
        var %t $numtok(%prefixesPlain, 32)

        ;; first we replace each instance of a prefix with their replacement.
        ;; this will include colouring the word after it, but not the rest of the line.
        while (%i <= %t) {

                var %input $replace(%input, $gettok(%prefixesPlain, %i, 32), $gettok(%prefixesMod, %i, 32))
                var %separator $gettok(%prefixesPlain, %i, 32)

                ;; isolate word following the prefix, and add a colour code at the end,
                var %word $gettok($gettok(%input, 2, $asc(%separator)), 1, 32)
                var %input $replace(%input, %word, $+(%word,))

                inc %i
        }

        ;; replace brackets. this is a simple search/replce loop
        var %i 1
        var %t $numtok(%bracketsPlain, 32)

        while (%i <= %t) {

                var %input $replace(%input, $gettok(%bracketsPlain, %i, 32), $gettok(%bracketsColorised, %i, 32))
                inc %i
        }

        echo -a %input
}


alias lineChar {

        var %nameTable lineHorizontal lineVertical cornerTopLeft cornerTopRight cornerBottomLeft cornerBottomRight splitRight splitLeft splitDown splitUp cross
        var %valueTable 9552 9553 9556 9559 9562 9565 9568 9571 9574 9577 9580

        var %token $findtok(%nameTable, $1, 1, 32)

        if (%token != $null) {

                return $chr($gettok(%valueTable, %token, 32))
        }

        else {

                mError [getLineChar] no such line character: $1
        }
}





















