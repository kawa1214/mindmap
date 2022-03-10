//
// Created by ryo kawamura on 2022/03/10.
//


import XCTest
import Foundation

@testable import mindmap

class TestsAst: XCTestCase {
    func testNextToken() {
        let input = """
                    ### h3text

                    ## h2text

                    # h1text

                    ##nohtext

                    test
                    test

                    test
                    """
        let tokens: Array<Token> = [
            Token(type: TokenType.h1, literal: "#"),
            Token(type: TokenType.text, literal: "test"),
        ]

        let lexer = Lexer(input: input)

        var tokenType = TokenType.unknown;
        while (tokenType != TokenType.eof) {
            let token = lexer.nextToken()
            tokenType = token.type
            print(["result: ", token]);
        }
    }
}
