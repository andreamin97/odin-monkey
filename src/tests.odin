package interpreter

import "core:testing"
import "core:fmt"

@(test)
TEST_NextToken :: proc(t: ^testing.T) {
    input := "=+(){},;"
    tokenizer := NewTokenizer(input, context.temp_allocator)

    tests :: [?]Token{
        {
            .ASSIGN,
            "=",
        },
        {
            .PLUS,
            "+",
        },
        {
            .LPAREN,
            "(",
        },
        {
            .RPAREN,
            ")",
        },
        {
            .LBRACE,
            "{",
        },
        {
            .RBRACE,
            "}",
        },
        {
            .COMMA,
            ",",
        },
        {
            .SEMICOLON,
            ";",
        },
        {
            .EOF,
            "",
        },
    }

    for tt, i in tests {
        tok := NextToken(tokenizer)
        msg := fmt.aprintf("TokenType Wrong, expected {0}, got {1}", tt, tok, allocator=context.temp_allocator)
        testing.expect(t, tok == tt, msg)
    }

    free_all(context.temp_allocator) }