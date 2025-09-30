package interpreter

Parser :: struct {
    tokenizer: ^Tokenizer,
    curr_token: Token,
    peek_token: Token,
}

NewParser :: proc (tokenizer: ^Tokenizer) -> Parser {
    p:=Parser{tokenizer = tokenizer}
    ParseNextToken(&p)
    ParseNextToken(&p)

    return p
}

ParseNextToken :: proc(parser: ^Parser) {
    parser.curr_token = parser.peek_token
    parser.peek_token = NextToken(parser.tokenizer)
}

ParseProgram :: proc(parser: ^Parser) -> (Program, bool) {
    return {}, false
}