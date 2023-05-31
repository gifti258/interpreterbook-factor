USING: assocs kernel strings words.symbol ;
IN: monkey.tokens

SYMBOLS:
    assign asterisk bang comma else eof eq false function gt
    ident if illegal int lbrace let lparen lt minus not-eq plus
    rbrace return rparen semicolon slash true ;

TUPLE: token
    { literal maybe{ string } }
    { type symbol initial: illegal } ;

C: <token> token

CONSTANT: keywords {
    { "else" else }
    { "false" false }
    { "fn" function }
    { "if" if }
    { "let" let }
    { "return" return }
    { "true" true }
}

: lookup-ident ( str -- type ) keywords at ident or ;
