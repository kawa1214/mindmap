import Foundation

enum TokenType: String {
    case test = "test"
    case unknown = "UNKNOWN"
    case eof = "EOF"
    
    case blank = "\n"
    
    case text = "TEXT"
    
    case h1 = "#"
    case h2 = "##"
    case h3 = "###"
}

struct Token {
    let type: TokenType
    let literal: String
}
