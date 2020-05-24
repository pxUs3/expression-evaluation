/**
 * @date 2020-05-20
 * @author Serhii Klevchuk
 * @version 1.0
 * @description <p> </p>
 */
public virtual with sharing class Node {
    private Object value;
    private Node leftChild;
    private Node rightChild;

    public Node() {
    }

    public Node(Object value) {
        this.value = value;
    }

    public Object getValue() {
        return this.value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public Node getLeftChild() {
        return this.leftChild;
    }

    public void setLeftChild(Node leftChild) {
        this.leftChild = leftChild;
    }

    public Node getRightChild() {
        return this.rightChild;
    }

    public void setRightChild(Node rightChild) {
        this.rightChild = rightChild;
    }

    public override String toString() {
        String result = '\n';
        result += this.getValue();
        String pointerForRight = '└──';
        String pointerForLeft = (this.getRightChild() != null) ? '├──' : '└──';


        result += this.buildToString('', pointerForLeft, this.getLeftChild(), this.getRightChild() != null);
        result += this.buildToString('', pointerForRight, this.getRightChild(), false);
        return result;
    }

    public String buildToString(String padding, String pointer, Node node, Boolean hasRightSibling) {
        String result = '';
        if (node != null) {
            result += '\n';
            result += padding;
            result += pointer;
            result += node.getValue();

            String paddingForBoth = padding + '   ';
            if (hasRightSibling) {
                paddingForBoth = padding + '│  ';
            }
            String pointerForRight = '└──';
            String pointerForLeft = (node.getRightChild() != null) ? '├──' : '└──';
            result += this.buildToString(paddingForBoth, pointerForLeft, node.getLeftChild(), node.getRightChild() != null);
            result += this.buildToString(paddingForBoth, pointerForRight, node.getRightChild(), false);
        }
        return result;
    }
}