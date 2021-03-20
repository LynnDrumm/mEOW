on *:load: {

        ;; load modules
        load -rs $+($scriptdir,math.mrc)
        load -rs $+($scriptdir,shell.mrc)
        load -rs $+($scriptdir,tools.mrc)
        load -rs $+($scriptdir,hex.mrc)
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