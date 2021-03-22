alias prideFlag {

        if ($hget(prideFlags) == $null) {

                generateFlagTable
        }

        var %flag $hfind(prideFlags, $1, 1)

        if (%flag != $null) {

                var %colors $hget(prideflags, %flag)
                var %items  $numtok(%colors, 32)
                var %i      1

                while (%i <= %items) {

                        var %value $gettok(%colors, %i, 32)
                        echo -a  $+ %value $+ $chr(44) $+ %value $+ $str(_, 12)
                        inc %i
                }
        }

        else {

                mError [prideFlag] flag $+(",$1,") not in database, sorry :\
        }
}

alias generateFlagTable {

        if ($hget(prideFlags) != $null) {

                if ($1 == force) {

                        hfree prideFlags
                }

                else {

                        mError [generateFlagTable] prideFlags table already exists. try /generateFlagTable force
                        return
                }
        }

        hmake prideFlags 50

        hadd prideFlags pan     63 54 59
        hadd prideFlags lgbt    52 53 54 56 60 61
        hadd prideFlags ace     88 93 98 37
        hadd prideFlags trans   70 86 98 86 70
        hadd prideFlags nb      54 98 61 89
}