/**
 * @date 2020-05-20
 * @author Serhii Klevchuk
 * @version 1.0
 * @description <p> </p>
 */
public with sharing class ExpressionParser {
    private ExpressionLexer lexer;
    private Token currentToken;

    public ExpressionParser(ExpressionLexer lexer) {
        this.lexer = lexer;
        this.currentToken = lexer.nextToken();
    }

    public Node parse() {
        Node root = this.factor();

        while (this.currentToken.getType() == Token.Type.OR_COMPARISON || this.currentToken.getType() == Token.Type.AND_COMPARISON) {
            Token token = this.currentToken;
            this.eat();

            Node node = new Node();
            node.setLeftChild(root);
            node.setValue(token);
            node.setRightChild(this.factor());
            root = node;
        }

        return root;
    }

    private Node factor() {
        Token previousToken = this.currentToken;
        if (previousToken.getType() == Token.Type.CONDITION) {
            this.eat();
            return new Node(previousToken);
        } else if (previousToken.getType() == Token.Type.LBRACKET) {
            this.eat();
            Node node = this.parse();
            this.eat();
            return node;
        }
        return null;
    }

    private void eat() {
        this.currentToken = this.lexer.nextToken();
    }
}