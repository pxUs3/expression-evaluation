/**
 * @date 2020-05-20
 * @author Serhii Klevchuk
 * @version 1.0
 * @description <p>Part of the tree that holds value and links to it's children nodes.</p>
 */
public virtual with sharing class Node {
    private Object value;
    private Node leftChild;
    private Node rightChild;

    public Node() {
    }
    /**
     * @param value any value for node to hold.
     */
    public Node(Object value) {
        this.value = value;
    }
    /**
     * @return Object value
     */
    public Object getValue() {
        return this.value;
    }
    /**
     * @param value any value for node to hold.
     */
    public void setValue(Object value) {
        this.value = value;
    }
    /**
     * @return left child
     */
    public Node getLeftChild() {
        return this.leftChild;
    }
    /**
     * @param leftChild left node child
     */
    public void setLeftChild(Node leftChild) {
        this.leftChild = leftChild;
    }
    /**
     * @return right child
     */
    public Node getRightChild() {
        return this.rightChild;
    }
    /**
     * @param rightChild right node child
     */
    public void setRightChild(Node rightChild) {
        this.rightChild = rightChild;
    }
    /**
     * Prints node in hierarchical format
     */
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