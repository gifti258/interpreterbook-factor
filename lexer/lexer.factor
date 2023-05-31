USING: accessors ascii combinators kernel math monkey.tokens
sequences slots.syntax strings ;
IN: monkey.lexer

TUPLE: lexer
    { input string }
    { position fixnum }
    ! current position in input (points to current char)
    { read-position fixnum }
    ! current reading position in input (after current char)
    { ch maybe{ fixnum } }
    ! current char under examination
    ;

: peek-char ( lexer -- ch ) get[ read-position input ] ?nth ;

: read-char ( lexer -- lexer )
    dup peek-char >>ch
    dup read-position>> >>position
    [ 1 + ] change-read-position ;

: <lexer> ( str -- lexer ) lexer new swap >>input read-char ;

: skip-whitespace ( lexer -- lexer )
    [ dup ch>> { 9 10 13 32 } member? ] [ read-char ] while ;

: ?1string ( ch -- str/f ) dup [ 1string ] when ;

: ?2token ( lexer str ch 2type 1type -- lexer literal type )
    [
        [
            [ over peek-char ] dip [ = ] keep
        ] dip '[ [ read-char ] dip _ suffix _ ]
    ] dip '[ _ ] kernel:if ;

: ?letter? ( ch -- ? )
    dup [ [ letter? ] [ CHAR: _ = ] bi or ] when ;

: (read) ( lexer quot -- str )
    [ [ position>> ] keep ] dip
    '[ dup peek-char @ ] [ read-char ] while
    get[ read-position input ] subseq ; inline

: read-identifier ( lexer -- str ) [ ?letter? ] (read) ;

: ?digit? ( ch -- ? ) dup [ digit? ] when ;

: read-number ( lexer -- string ) [ ?digit? ] (read) ;

: (next-token) ( lexer str/f ch -- lexer literal type )
    {
        { [ dup ?letter? ] [
            2drop dup read-identifier dup lookup-ident
        ] }
        { [ dup digit? ] [ 2drop dup read-number int ] }
        [ drop illegal ]
    } cond ;

: next-token ( lexer -- token )
    skip-whitespace dup ch>> [ ?1string ] keep {
        { CHAR: = [ CHAR: = eq assign ?2token ] }
        { CHAR: ! [ CHAR: = not-eq bang ?2token ] }
        { CHAR: + [ plus ] }
        { CHAR: - [ minus ] }
        { CHAR: * [ asterisk ] }
        { CHAR: / [ slash ] }
        { CHAR: < [ lt ] }
        { CHAR: > [ gt ] }
        { CHAR: , [ comma ] }
        { CHAR: ; [ semicolon ] }
        { CHAR: ( [ lparen ] }
        { CHAR: ) [ rparen ] }
        { CHAR: { [ lbrace ] }
        { CHAR: } [ rbrace ] }
        { f [ eof ] }
        [ (next-token) ]
    } case <token> [ read-char drop ] dip ;
