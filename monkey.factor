USING: formatting io monkey.repl system-info ;
IN: monkey

: main ( -- )
    username
    "Hello %s! This is the Monkey programming language!\n"
    printf "Feel free to type in commands" print start ;

MAIN: main
