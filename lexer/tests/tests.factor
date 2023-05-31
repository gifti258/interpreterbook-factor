USING: accessors kernel monkey.lexer monkey.tokens multiline
sequences ;
IN: monkey.lexer.tests

CONSTANT: test [[
let five = 5;
let ten = 10;

let add = fn(x, y) {
  x + y;
};

let result = add(five, ten);
!-/*5;
5 < 10 > 5;

if (5 < 10) {
    return true;
} else {
    return false;
}

10 == 10;
10 != 9;
]]

: tokens ( str -- seq )
    <lexer> [
        dup next-token dup type>> eof = not
    ] [ ] produce 2nip ;
