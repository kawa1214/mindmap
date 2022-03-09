import Foundation
import AppKit

class Lexer {
    let input: String
    
    var prevPosition: String.Index? // 一つ前の文字
    var position: String.Index? //現在の文字
    var readPosition: String.Index //次の文字
    var ch: Character? //現在検査中の文字
    
    init(input: String) {
        self.input = input
        self.prevPosition = nil
        self.readPosition = self.input.index(after: self.input.startIndex)
        self.position = self.input.startIndex
        self.ch = self.input[self.readPosition]
        //self.readChar()
    }
    
    func nextToken() -> Token {
        if (self.ch == nil) {
            return Token(type: TokenType.eof, literal: TokenType.eof.rawValue)
        }

        if isHTag() && isStartHtag() {
            let hTagToken = readHTag()
            return hTagToken;
        }
        
        let readToken = readText()
        //print(["readToken: ",readToken])

        self.readChar()

        return readToken


        if (self.ch == nil) {
            return Token(type: TokenType.eof, literal: TokenType.eof.rawValue)
        }

        return Token(type: TokenType.unknown, literal: String(self.input[position!] ?? " "))
    }
    
    func isReadText() -> Bool {
        if (readPosition.hashValue == input.endIndex.hashValue ) {
            return false;
        }
        let nextReadPosition = self.input.index(after: readPosition)
        return !(self.input[self.readPosition] == "\n" && self.input[nextReadPosition] == "\n")
    }
    
    func isReadDoubleLineFeed() -> Bool {
        if (readPosition.hashValue == input.endIndex.hashValue ) {
            return false;
        }
        
        let nextReadPosition = self.input.index(after: readPosition)

        return self.input[self.readPosition] == "\n" && self.input[nextReadPosition] == "\n"
    }
    
    func readText() -> Token {
        let startPosition = self.position!;

        while isReadText() {
            self.readChar()
        }
        
        let indexRange = startPosition..<self.readPosition
        let result = self.input.substring(with: indexRange)
        
        if isReadDoubleLineFeed() {
            //print("double line feed")
            readChar()
            readChar()
        }

        return Token(type: TokenType.text, literal: result)
    }
    
    func isStartHtag() -> Bool {
        //print(["prev", self.prevPosition])
        if (self.prevPosition == nil) {
            return true;
        }
        //print(["isStartHTag", self.input[self.prevPosition!]])
        return self.input[self.prevPosition!] == "\n"
    }

    func isHTag() -> Bool {
        return self.ch == "#"
    }
    
    func isReadHTag() -> Bool {
        return self.input[self.readPosition] == "#"
    }

    func readHTag() -> Token {
        let startPosition = self.position!;
        let save = self
        
        while isHTag() {
            self.readChar()
        }

        //
        
        let indexRange = startPosition..<self.position!
        let result = self.input.substring(with: indexRange)

        // # 後のスペースをスキップする
        self.readChar()

        if (result == "#") {
            return Token(type: TokenType.h1, literal: "#")
        } else if (result == "##") {
            return Token(type: TokenType.h2, literal: "##")
        } else if (result == "###") {
            return Token(type: TokenType.h3, literal: "###")
        }

        return Token(type: TokenType.unknown, literal: "")
    }

    // 現在位置を進める。終端に達した場合、chをnilとする
    func readChar() {
        //print("read char: ", self.input[self.readPosition])
        if (self.prevPosition != nil) {
            //print("prev char: ", self.input[self.prevPosition!])
        }
        
       // print([(self.input.endIndex.encodedOffset), self.readPosition.encodedOffset])
        
        /*
        if ((self.input.endIndex.encodedOffset)+1 == self.readPosition.encodedOffset) {
            self.ch = nil
            return;
        }
        */
        
        //print(readPosition.hashValue, input.endIndex.hashValue)
        
        if (readPosition.hashValue == input.endIndex.hashValue) {
            self.ch = nil
            self.prevPosition = self.position
            self.position = self.readPosition
            return;
        }
        

        
        let index = self.input.index(self.readPosition, offsetBy: 0)
        
        //self.input.endIndex.samePosition(in: )
        self.ch = self.input[index]
        
        
        self.prevPosition = self.position
        self.position = self.readPosition
        self.readPosition = self.input.index(after: readPosition)
    }
    
    /*func readIdentifier() {
    
    }*/
}
