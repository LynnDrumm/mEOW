;; usage:
;;
;;   $1 is any &binvar
;;   $2 is optional offset (default = 0)
;;   $3 is optional line length
alias getHexLine {

        ;; check if 1st parameter is a &binvar
        if ($bvar($1)) {

                var %binData $1

                ;; check if second parameter is present
                if ($2) {

                        ;; set %byteOffset to the value of the 2nd parameter + 1,
                        ;; because 0 makes $bvar() return the length of the binvar.
                        ;; if 3rd parameter is present, set %lineLength to it's value,
                        ;; otherwise, use the default (16)
                        var %byteOffset = $calc($2 + 1)
                        var %lineLength = $iif($3, $3, 16)
                }
                else {

                        ;; set default values for %byteOffset and %lineLength
                        var %byteOffset = 1
                        var %lineLength = 16
                }

                var %i = 0

                while (%i < %lineLength) {

                                        ;; get single byte
                        var %byte       $bvar(%binData, $calc(%byteOffset + %i))
                                        ;; get hex value (with padding if < 0x10)
                        var %hexValue   $numPad($base(%byte, 10, 16), 2)
                                        ;; check for non-printable characters, convert them if necessary,
                                        ;; and turn the ascii value into it's corresponding character.
                        var %ascValue   $chr($fixBlankChars(%byte))
                                        ;; construct printable lines for hex and ascii values
                        var %hexLine    $instok(%hexLine, %hexValue, %lineLength, 32)
                        var %ascLine    $+(%ascLine,%ascValue)

                        inc %i
                }

                ;; msl being "broken" as it is, you can absolutely make an identifier contain
                ;; periods* and parse them as separate parameters, because that's totally a sane
                ;; way for me to parse two different sets of parameters.

                ;; *you can use literally any character except spaces probably, periods just
                ;; seemed the most sane. I was going to use backslashes first, don't judge me.

                if ($findtok($prop, prefix, 46)) {

                        ;; construct the prefix. this is basically just the offset we're printing
                        ;; from, not the absolute offset value in the file (I think), but maybe
                        ;; I'll change that at some point.
                        var %prefix $+([,$numPad($base($calc(%byteOffset - 1), 10, 16), 4),])

                        ;; since this is the first part of the output we're constructing,
                        ;; we don't really need to add the output to itself (yet)
                        var %output %prefix

                }

                if ($findtok($prop, hex, 46)) {

                        ;; if hex property is present, add hex line to the output.
                        var %output %output %hexLine
                }

                if ($findtok($prop, ascii, 46)) {

                        ;; if ascii property is present, add the ascii line to the output.
                        var %ouput %output %ascLine
                }

                return %ouput
        }

        else {

                mError [getHexLine] supplied binvar is empty/unexistent: $1
        }
}

alias hexDump {

        ;; check if input exists
        if (($1 != $null) && ($2 != $null) && ($3- != $null)) {

                var %offset = $1
                var %length = $2

                if ($3 isnum) {

                        var %lineSize $3
                        var %file $4-
                }

                else {
                        var %lineSize 16
                        var %file $3-
                }

                if ($isfile(%file) == $true) {

                        echo -s %length bytes from $+(%offset,-,$calc(%offset + %length)) $+($chr(40),%file,$chr(41))
                        set %hexDump.counter 0

                        hexDump_loop &hexDump %offset %length %file
                }

                else {

                        mError [hexDump] File not found: $3-
                }
        }

        else {

                mError [hexDump] Invalid or insufficient parameters
                mError [hexDump] Format: /hexDump <offset> <length> <file>
        }

        return
        :error
        mError [hexDump] $error
}

alias hexDump_loop {

        ;; read the input file with specified offset/length

        ;; detect if 4th parameter is the line length number.
        ;; this could probably be cleaner but the vodka inside me does not care
        if ($4 isnum) {

                var %lineLength $4
                bread $qt($5-) $2 $3 $1
        }
        else {

                var %lineLength 16
                bread $qt($4-) $2 $3 $1
        }

        var %i = $2

        ;; start looping through all the bytes
        if (%i < $3) {

                echo -s $getHexLine($1, %i, %lineLength).prefix.hex.ascii
                inc %i %lineLength
                .timerhexDump -h 1 0 hexDump_loop &hexDump %i $3 $4-
        }
}

alias -l fixBlankChars {

        ;; list of characters that can't reasonably be printed.
        ;; these get replaced with a . (ascii 46)

        ;; edge case check for standard spaces (ascii 32)
        if ($1 == 32) {

                ;; if present, return a non-breaking space (ascii 160)
                return 160
        }

        else {

                var %nonPrintableChars 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 129 132 138 144

                if ($findtok(%nonPrintableChars, $1, 32) != $null) {

                        return 46
                }

                else {

                        return $1
                }
        }
}