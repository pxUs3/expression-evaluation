/**
 * @date 2020-05-20
 * @author Serhii Klevchuk
 * @version 1.0
 * @description <p> </p>
 */
public with sharing class Token {
    private Type type;
    private Object value;

    public Token(Type type) {
        this.type = type;
    }

    public Token(Type type, Object value) {
        this.type = type;
        this.value = value;
    }

    public Type getType() {
        return this.type;
    }

    public Object getValue() {
        return this.value;
    }
    public enum Type {
        AND_COMPARISON, OR_COMPARISON, CONDITION, LBRACKET, RBRACKET, EOF
    }
}