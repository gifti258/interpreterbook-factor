USING: accessors io kernel monkey.lexer monkey.tokens
prettyprint ;
IN: monkey.repl

CONSTANT: prompt ">> "

: start ( -- )
    prompt write readln [
        <lexer> [ dup next-token dup type>> eof = ] [ ... ] until
        2drop start
    ] when* ;
