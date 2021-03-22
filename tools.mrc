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