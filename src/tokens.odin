#+feature dynamic-literals
package interpreter

import "core:strconv"
TokenType :: enum (u8) {
	ILLEGAL = 0,
	EOF,
	// Identifiers + literals
	IDENT,
	INT,
	// Operators
	ASSIGN,
	PLUS,
	BANG,
	MINUS,
	SLASH,
	ASTERISK,
	LT,
	GT,
	EQ,
	NOT_EQ,
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
	TRUE,
	FALSE,
	IF,
	ELSE,
	RETURN,
}

Token :: struct {
	type:    TokenType,
	literal: string,
}

Keywords := map[string]TokenType {
	"let" = .LET,
	"fn"  = .FUNCTION,
	"true" = .TRUE,
	"false" = .FALSE,
	"if" = .IF,
	"else" = .ELSE,
	"return" = .RETURN,
}


Tokenizer :: struct {
	input:         string,
	input_len:     int,
	position:      int, // current char position
	read_position: int, // next char position
	character:     byte, // current character
}

NewTokenizer :: proc(s: string, allocator := context.allocator) -> ^Tokenizer {
	tokenizer := new(Tokenizer, allocator)
	tokenizer.input = s
	tokenizer.input_len = len(s)
	NextCharacter(tokenizer)
	return tokenizer
}

NextCharacter :: proc(tokenizer: ^Tokenizer) {
	if tokenizer.read_position >= tokenizer.input_len {
		tokenizer.character = 0
	} else {
		tokenizer.character = tokenizer.input[tokenizer.read_position]
		tokenizer.position = tokenizer.read_position
		tokenizer.read_position += 1
	}
}

SkipWhitespace :: proc(tokenizer: ^Tokenizer) {
	for tokenizer.character == ' ' \
		|| tokenizer.character == '\t' \
		|| tokenizer.character == '\n' \
		|| tokenizer.character == '\r' {
			NextCharacter(tokenizer)
		}
}

NextToken :: proc(tokenizer: ^Tokenizer) -> Token {
	tok: Token
	SkipWhitespace(tokenizer)
	switch tokenizer.character {
	case '=':
		if PeekChar(tokenizer) == '=' {
			NextCharacter(tokenizer)
			tok = {.EQ, "=="}
		}
		else {
			{tok = {.ASSIGN, "="}}
		}
	case ';':
		{tok = {.SEMICOLON, ";"}}
	case '(':
		{tok = {.LPAREN, "("}}
	case ')':
		{tok = {.RPAREN, ")"}}
	case ',':
		{tok = {.COMMA, ","}}
	case '+':
		{tok = {.PLUS, "+"}}
	case '{':
		{tok = {.LBRACE, "{"}}
	case '}':
		{tok = {.RBRACE, "}"}}
	case '!':
		if PeekChar(tokenizer) == '=' {
			NextCharacter(tokenizer)
			tok = {.NOT_EQ, "!="}
		}
		else {
			tok = {.BANG, "!"}
		}
	case '-':
		{tok = {.MINUS, "-"}}
	case '/':
		{tok = {.SLASH, "/"}}
	case '*':
		{tok = {.ASTERISK, "*"}}
	case '<':
		{tok = {.LT, "<"}}
	case '>':
		{tok = {.GT, ">"}}
	case 0:
		{tok = {.EOF, ""}}
	// Handle letters
	case:
		{
			if IsLetter(tokenizer.character) {
				// Read Identifier
				ident := ReadIdentifier(tokenizer)
				// Lookup Identifier
				// separate keywords from identifiers
				return LookupIdentifier(ident)
			} else if IsDigit(tokenizer.character) {
				// Handle Digits
				value := ReadInt(tokenizer)
				return {.INT, value}
			} else {
				// Not a recognized character, ILLEGAL
				tok = {.ILLEGAL, ""}
			}
		}
	}
	NextCharacter(tokenizer)
	return tok
}

IsLetter :: proc(ch: byte) -> bool {
	return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || ch == '_'
}

IsDigit :: proc(ch: byte) -> bool {
	return '0' <= ch && ch <= '9'
}

ReadIdentifier :: proc(tokenizer: ^Tokenizer) -> string {
	pos := tokenizer.position
	for IsLetter(tokenizer.character) {
		NextCharacter(tokenizer)
	}

	return tokenizer.input[pos:tokenizer.position]
}

LookupIdentifier :: proc(ident: string) -> Token {
	keyword, found := Keywords[ident]
	if found do return {keyword, ident}
	
	return Token{.IDENT, ident}
}

ReadInt :: proc(tokenizer: ^Tokenizer) -> string {
	pos := tokenizer.position
	for IsDigit(tokenizer.character) {
		NextCharacter(tokenizer)
	}
	return tokenizer.input[pos:tokenizer.position]
}

PeekChar :: proc(tokenizer: ^Tokenizer) -> byte {
	if tokenizer.position >= tokenizer.input_len do return 0
	else do return tokenizer.input[tokenizer.read_position]
}