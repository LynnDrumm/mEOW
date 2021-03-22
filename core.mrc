on *:load: {

        ;; load modules
        var %files $findfile($scriptdir, *.mrc, 0, 1, loadFile $1-)

        echo -s loaded %files files.
}

alias -l loadFile {

        ;; modules to exclude from loading
        var %exclude core.mrc

        if ($nopath($1-) !isin %exclude) {

                .load -rs $qt($1-)

        }
}

alias initWindow {

        var %win $1
        var %parameters $2

        if ($left(%win, 1) != @) {

                var %win $+(@,%win)
        }

        if ($window(%win) != $null) {

                if ($prop == force) {

                        clear %win
                }

                else {

                        echo -s window already exists, try using $initWindow().force to override
                        return $false
                }
        }

        window $+(-,%parameters) %win

        return $true
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
