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
}