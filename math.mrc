;; calculate percentage.
;; $1 is low value, $2 is high value, $3 is optional rounding factor.
;; property .suf returns result with % suffix.
alias percent {

        ;; calculate percentage with 1st and 2nd parameter
        var %percentage = $calc(($1 / $2) * 100)

        if ($3 != $null) {

                ;; if 3rd parameter is present, use it as a rounding factor
                var %percentage = $round(%percentage, $3)
        }

        if ($prop == suf) {

                ;; if .suf property is present, add a % at the end.
                var %percentage = $+(%percentage,$chr(37))
        }

        return %percentage
}

;; calculate average number for a set.
;; $1- is any amount of values.
alias average {

        var %totalValues $numtok($1-, 32)
        var %i = 1

        while (%i <= %totalValues) {

                var %result = $calc(%result + $gettok($1-, %i, 32))
                inc %i
        }

        return $calc(%result / %totalValues)
}

;; $1 is number to be padded, $2 is # total length of number
alias numpad {

        return $+($str(0, $calc($2 - $len($1))),$1)
}