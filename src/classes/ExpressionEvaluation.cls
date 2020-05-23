/**
 * @date 2020-05-19
 * @author Serhii Klevchuk
 * @version 1.0
 * @description <p> </p>
 */
public with sharing class ExpressionEvaluation {
    private Map<Object, Condition> conditions = new Map<Object, Condition>();
    private String expression;

    public ExpressionEvaluation setExpression(String expression) {
        this.expression = expression;
        return this;
    }
    public ExpressionEvaluation setConditions(List<Condition> conditions) {
        for (Condition condition : conditions) {
            this.conditions.put(condition.getName(), condition);
        }
        return this;
    }

    public Boolean isTrue() {
        if(String.isBlank(this.expression)){
            return true;
        }
        ExpressionParser parser = new ExpressionParser(new ExpressionLexer(expression));
        ExpressionInterpreter interpreter = new ExpressionInterpreter(parser);
        interpreter.setConditions(this.conditions);
        return interpreter.getResult();
    }
}