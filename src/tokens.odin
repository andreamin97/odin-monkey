package interpreter

import "core:strconv"
TokenType :: enum(u8) {
    ILLEGAL = 0,
    EOF,
    // Identifiers + literals
    IDENT,
    INT,
    // Operators
    ASSIGN,
    PLUS,
    // Delimiters
    COMMA,
    SEMICOLON,
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,
    //Keywords
    FUNCTION,
    LET,
}

Token :: struct {
    type: TokenType,
    literal: string,
}

Tokenizer :: struct {
    input: string,
    input_len: int,
    position: int, // current char position
    read_position: int, // next char position
    character: byte, // current character
}

NewTokenizer :: proc(s: string, allocator:=context.allocator) -> ^Tokenizer {
    tokenizer := new(Tokenizer, allocator)
    tokenizer.input = s
    tokenizer.input_len = len(s)
    NextCharacter(tokenizer)
    return tokenizer
}

NextCharacter :: proc(tokenizer: ^Tokenizer) {
    if tokenizer.read_position >= tokenizer.input_len {
        tokenizer.character = 0
    }
    else {
        tokenizer.character = tokenizer.input[tokenizer.read_position]
        tokenizer.position = tokenizer.read_position
        tokenizer.read_position += 1
    }
}

NextToken :: proc(tokenizer: ^Tokenizer) -> Token { 
    tok : Token
    // Skip whitespace
    switch tokenizer.character {
        case '=': {tok = {.ASSIGN, "="}}
        case ';': {tok = {.SEMICOLON, ";"}}
        case '(': {tok = {.LPAREN, "("}}
        case ')': {tok = {.RPAREN, ")"}}
        case ',': {tok = {.COMMA, ","}}
        case '+': {tok = {.PLUS, "+"}}
        case '{': {tok = {.LBRACE, "{"}}
        case '}': {tok = {.RBRACE, "}"}}
        case 0:   {tok = {.EOF, ""}}
        // Handle letters
        case:{
            if IsLetter(tokenizer.character) {
                // Read Identifier
                ReadIdentifier(tokenizer)
                // Lookup Identifier
                    // separate keywords from identifiers
            }
            else if IsDigit(tokenizer.character) {
                // Handle Digits
            }
            else {
                // Not a recognized character, ILLEGAL
                tok = { .ILLEGAL, ""}
            }
        } 
   }
   NextCharacter(tokenizer)
   return tok 
}

IsLetter :: proc(ch: byte) -> bool {
    return false
}

IsDigit :: proc(ch: byte) -> bool {
    return false
}

ReadIdentifier :: proc(tokenizer: ^Tokenizer) -> string {
    pos := tokenizer.position
    for IsLetter(tokenizer.character) {
        NextCharacter(tokenizer)
    }
        
    return tokenizer.input[pos:tokenizer.position]
}