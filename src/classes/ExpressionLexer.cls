/**
 * @date 2020-05-20
 * @author Serhii Klevchuk
 * @version 1.0
 * @description <p> </p>
 */
public with sharing class ExpressionLexer {
    private List<String> chars;
    private Integer pos = 0;

    public ExpressionLexer(String text) {
        this.chars = text.trim().toLowerCase().split('');
    }

    public Token nextToken() {
        while (this.notEOF()) {
            if (this.currentChar() == ' ' || this.currentChar() == '') {
                this.skipWhitespace();
                continue;
            }

            if (this.currentChar() == '(') {
                this.advance();
                return new Token(Token.Type.LBRACKET);
            }
            if (this.currentChar() == ')') {
                this.advance();
                return new Token(Token.Type.RBRACKET);
            }
            if (this.isAndComparison()) {
                this.advance(3);
                return new Token(Token.Type.AND_COMPARISON);
            }

            if (this.isOrComparison()) {
                this.advance(2);
                return new Token(Token.Type.OR_COMPARISON);
            }
            if (this.currentChar() != null) {
                String name = '';
                while (this.nameNotEnded()) {
                    name += this.currentChar();
                    this.advance();
                }
                if (String.isNotBlank(name)) {
                    return new Token(Token.Type.CONDITION, name);
                }
            }

        }
        return new Token(Token.Type.EOF);
    }

    private Boolean nameNotEnded() {
        return String.isNotBlank(this.currentChar()) && this.currentChar() != ' '
                && this.currentChar() != ')' && this.currentChar() != '(';
    }

    private Boolean isOrComparison() {
        return this.currentChar() == 'o' && this.peek(1) == 'r'
                && (this.peek(2) == ' ' || this.peek(3) == '(');
    }

    private Boolean isAndComparison() {
        return this.currentChar() == 'a' && this.peek(1) == 'n' && this.peek(2) == 'd'
                && (this.peek(3) == ' ' || this.peek(3) == '(');
    }

    private String currentChar() {
        if (this.pos < this.chars.size()) {
            return this.chars[this.pos];
        } else {
            return null;
        }
    }

    private String peek(Integer chars) {
        Integer peekPos = this.pos + chars;
        if (peekPos < this.chars.size()) {
            return this.chars[peekPos];
        } else {
            return null;
        }
    }
    private void advance() {
        this.pos++;
    }

    private void advance(Integer i) {
        this.pos += i;
    }

    private void skipWhitespace() {
        while (this.notEOF() && (this.currentChar() == ' ' || this.currentChar() == '')) {
            this.advance();
        }
    }
    private Boolean notEOF() {
        return this.pos < this.chars.size();
    }
}