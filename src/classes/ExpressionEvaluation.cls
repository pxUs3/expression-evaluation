/**
 * @date 2020-05-19
 * @author Serhii Klevchuk
 * @version 1.0
 * @description <p> </p>
 */
public with sharing class ExpressionEvaluation {
    private static final Map<String, Node> treeMap = new Map<String, Node>();
    private Map<Object, Condition> conditions = new Map<Object, Condition>();
    private String expression;

    public ExpressionEvaluation setExpression(String expression) {
        this.expression = expression;
        return this;
    }
    public ExpressionEvaluation setConditions(List<Condition> conditions) {
        for (Condition condition : conditions) {
            this.conditions.put(condition.getName().toLowerCase(), condition);
        }
        return this;
    }

    public Boolean isTrue() {
        if(String.isBlank(this.expression)){
            return true;
        }
        Node expressionTree = treeMap.get(expression);
        if(expressionTree == null){
            ExpressionParser parser = new ExpressionParser(new ExpressionLexer(expression));
            expressionTree = parser.parse();
            treeMap.put(expression, expressionTree);
        }
        ExpressionInterpreter interpreter = new ExpressionInterpreter(expressionTree);
        interpreter.setConditions(this.conditions);
        return interpreter.getResult();
    }
}