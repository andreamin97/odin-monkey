package interpreter


Statement :: union {
    LetStatement,
}

TokenLiteral_Statement :: proc(statement: Statement) -> string {return ""}


Expression :: union {
    Identifier,
}

TokenLiteral_Expression :: proc(expr: Expression) -> string {return ""}


Program :: struct {
    Statements: []Statement,
}

TokenLiteral_Program :: proc(program: Program) -> string {
    if len(program.Statements) > 0 {
        return TokenLiteral(program.Statements[0]) 
    }
    return ""
}


LetStatement :: struct {
    token: Token,
    name: ^Identifier,
    value: Expression,
}

TokenLiteral_Let :: proc(statement: LetStatement) -> string {
    return statement.token.literal
} 


Identifier :: struct {
    token: Token,
    value: string,
}

TokenLiteral_Ident :: proc(ident: Identifier) -> string {
    return ident.token.literal
}


// Since `Statement` is a union, is there any difference using a single function and switching on the type of the parameter, over a proc group?
// TODO Test it
TokenLiteral :: proc {
    TokenLiteral_Program, 
    TokenLiteral_Statement, 
    TokenLiteral_Expression,
    TokenLiteral_Let,
    TokenLiteral_Ident,
}



