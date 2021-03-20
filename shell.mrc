alias mShell {

        window @mShell.1
        set %mShell.buffer
        set %mShell.dir $scriptdir
        set %mShell.prefix $+($mnick,@,$envvar(COMPUTERNAME)) $+($scriptdir,:)
        echo @mShell.1 %mShell.prefix
}

on *:char:@mShell.*:*: {

        ;;handle control chars
        if ($keyval < 32) {

                set %mShell.buffer $controlCharHandler($keyval, $active, %mShell.buffer)C:
        }

        else {

                set %mShell.buffer $+(%mShell.buffer,$keychar)
        }

        rline $active $line($active, 0) %mShell.prefix %mShell.buffer
}

alias -l controlCharHandler {

        echo -s control char pressed: $1

        ;; backspace
        if ($1 == 8) {

                return $left($3-, -1)
        }

        ;; return
        elseif ($1 == 13) {

                echo $2 $chr(160)
                return
        }
}