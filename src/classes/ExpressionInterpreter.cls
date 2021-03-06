/**
 * @date 2020-05-23
 * @author Serhii Klevchuk
 * @version 1.0
 * @description <p> </p>
 */
public with sharing class ExpressionInterpreter implements NodeVisitor {
    private Map<Object, Condition> conditionsByName = new Map<Object, Condition>();
    private Node tree;

    public ExpressionInterpreter(Node tree) {
        this.tree = tree;
    }

    public void setConditions(Map<Object, Condition> conditionsByName) {
        this.conditionsByName = conditionsByName;
    }

    public Boolean getResult() {
        if (this.tree == null) {
            return false;
        }

        return this.visit(this.tree);
    }

    public Boolean visit(Node node) {
        Token nodeValue = (Token) node.getValue();
        if (nodeValue.getType() == Token.Type.CONDITION) {
            return this.visitCondition(node);
        } else if (nodeValue.getType() == Token.Type.OR_COMPARISON) {
            return this.visitOr(node);
        } else if (nodeValue.getType() == Token.Type.AND_COMPARISON) {
            return this.visitAnd(node);
        }
        return null;
    }

    private Boolean visitCondition(Node node) {
        Token nodeToken = (Token) node.getValue();
        Condition condition = conditionsByName.get(nodeToken.getValue());
        if (condition == null) {
            return false;
        } else {
            return condition.isTrue();
        }
    }
    private Boolean visitOr(Node node) {
        return (Boolean) this.visit(node.getLeftChild()) || (Boolean) this.visit(node.getRightChild());
    }
    private Boolean visitAnd(Node node) {
        return (Boolean) this.visit(node.getLeftChild()) && (Boolean) this.visit(node.getRightChild());
    }
}