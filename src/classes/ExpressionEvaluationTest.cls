/**
 * @date 2020-05-20
 * @author Serhii Klevchuk
 * @version 1.0
 * @description <p> </p>
 */
@IsTest
public with sharing class ExpressionEvaluationTest {
    public static final String simpleExpression = '1 and 2 or 3 ';
    public static final String complexExpression = 'one and two2 or ((three3 or 4)and(5 or 3))';
    public static final Map<Object, Condition> conditions = new Map<Object, Condition>{
            '1' => new TestCondition('1', false),
            '2' => new TestCondition('2', true),
            '3' => new TestCondition('3', false),
            '4' => new TestCondition('4', true),
            '5' => new TestCondition('5', false),
            'one' => new TestCondition('one', true),
            'two2' => new TestCondition('two2', false),
            'three3' => new TestCondition('three3', true),
            'name' => new TestCondition('name', false),
            'false' => new TestCondition('false', false),
            'trueFalse' => new TestCondition('trueFalse', false),
            'definitelyTrue' => new TestCondition('definitelyTrue', true),
            'name1' => new TestCondition('name1', true)
    };

    @IsTest
    public static void lexerSimple() {
        ExpressionLexer lexer = new ExpressionLexer(simpleExpression);
        System.assertEquals('1', lexer.nextToken().getValue());
        System.assertEquals(Token.Type.AND_COMPARISON, lexer.nextToken().getType());
        System.assertEquals('2', lexer.nextToken().getValue());
        System.assertEquals(Token.Type.OR_COMPARISON, lexer.nextToken().getType());
        System.assertEquals('3', lexer.nextToken().getValue());
        System.assertEquals(Token.Type.EOF, lexer.nextToken().getType());
        System.assertEquals(Token.Type.EOF, lexer.nextToken().getType());
        System.assertEquals(Token.Type.EOF, lexer.nextToken().getType());
    }
    @IsTest
    public static void lexerComplex() {
        ExpressionLexer lexer = new ExpressionLexer(complexExpression);
        System.assertEquals('one', lexer.nextToken().getValue());
        System.assertEquals(Token.Type.AND_COMPARISON, lexer.nextToken().getType());
        System.assertEquals('two2', lexer.nextToken().getValue());
        System.assertEquals(Token.Type.OR_COMPARISON, lexer.nextToken().getType());
        System.assertEquals(Token.Type.LBRACKET, lexer.nextToken().getType());
        System.assertEquals(Token.Type.LBRACKET, lexer.nextToken().getType());
        System.assertEquals('three3', lexer.nextToken().getValue());
        System.assertEquals(Token.Type.OR_COMPARISON, lexer.nextToken().getType());
        System.assertEquals('4', lexer.nextToken().getValue());
        System.assertEquals(Token.Type.RBRACKET, lexer.nextToken().getType());
        System.assertEquals(Token.Type.AND_COMPARISON, lexer.nextToken().getType());
        System.assertEquals(Token.Type.LBRACKET, lexer.nextToken().getType());
        System.assertEquals('5', lexer.nextToken().getValue());
        System.assertEquals(Token.Type.OR_COMPARISON, lexer.nextToken().getType());
        System.assertEquals('3', lexer.nextToken().getValue());
        System.assertEquals(Token.Type.RBRACKET, lexer.nextToken().getType());
        System.assertEquals(Token.Type.RBRACKET, lexer.nextToken().getType());
        System.assertEquals(Token.Type.EOF, lexer.nextToken().getType());
        System.assertEquals(Token.Type.EOF, lexer.nextToken().getType());
    }

    @IsTest
    public static void simpleEvaluation1() {
        String expression = '1 or 2';
        ExpressionParser expressionParser = new ExpressionParser(new ExpressionLexer(expression));
        ExpressionInterpreter interpreter = new ExpressionInterpreter(expressionParser.parse());
        interpreter.setConditions(conditions);
        Boolean expected = conditions.get('1').isTrue() || conditions.get('2').isTrue();
        Boolean received = interpreter.getResult();
        System.assertEquals(expected, received);
    }
    @IsTest
    public static void simpleEvaluation2() {
        String expression = '1 and 3 and 4 and 3 and one and trueFalse and name1';
        ExpressionEvaluation evaluation = new ExpressionEvaluation();
        evaluation.setConditions(conditions.values());
        evaluation.setExpression(expression);

        Boolean expected = conditions.get('1').isTrue()
                && conditions.get('3').isTrue()
                && conditions.get('4').isTrue()
                && conditions.get('3').isTrue()
                && conditions.get('one').isTrue()
                && conditions.get('trueFalse').isTrue()
                && conditions.get('name1').isTrue();
        Boolean received = evaluation.isTrue();
        System.assertEquals(expected, received);
    }
    @IsTest
    public static void complexEvaluation() {
        String expression = '(1 and 3) and (4 and 3) and (trueFalse or (definitelyTrue and name1))';
        ExpressionEvaluation evaluation = new ExpressionEvaluation();
        evaluation.setConditions(conditions.values());
        evaluation.setExpression(expression);

        Boolean expected = (conditions.get('1').isTrue() && conditions.get('3').isTrue())
                && (conditions.get('4').isTrue() && conditions.get('3').isTrue())
                && (conditions.get('trueFalse').isTrue()
                || (conditions.get('definitelyTrue').isTrue() && conditions.get('name1').isTrue()));
        Boolean received = evaluation.isTrue();
        System.assertEquals(expected, received);
    }

    @IsTest
    public static void complexEvaluation2() {
        String expression = '2 AND 4 AND ((three3 AND name1) OR (2 AND 4 AND name1 AND three3 AND definitelyTrue) or ((three3 AND name1) OR (2 AND 4 AND name1 AND three3 AND definitelyTrue))';
        ExpressionEvaluation evaluation = new ExpressionEvaluation();
        evaluation.setConditions(conditions.values());
        evaluation.setExpression(expression);
        Boolean result = evaluation.isTrue();
        System.assert(result);
    }

    @IsTest
    public static void nullTest() {
        String expression = '(1 and 3) and (4 and 3) and (trueFalse or (definitelyTrue and name1))';
        ExpressionEvaluation evaluation = new ExpressionEvaluation();
        evaluation.setConditions(conditions.values());
        evaluation.setExpression(expression);

        Boolean expected = (conditions.get('1').isTrue() && conditions.get('3').isTrue())
                && (conditions.get('4').isTrue() && conditions.get('3').isTrue())
                && (conditions.get('trueFalse').isTrue()
                || (conditions.get('definitelyTrue').isTrue() && conditions.get('name1').isTrue()));
        Boolean received = evaluation.isTrue();
        System.assertEquals(expected, received);
    }
    @IsTest
    public static void printBlankTest() {
        String expression = '2 AND 4 AND ((three3 AND name1) OR (2 AND 4 AND name1 AND three3 AND definitelyTrue))';
        ExpressionParser parser = new ExpressionParser(new ExpressionLexer(expression));
        Node root = parser.parse();
        root.print();
        System.assert(true);
    }
    public class TestCondition implements Condition {
        private Boolean value;
        private String name;
        public TestCondition(String name, Boolean value) {
            this.name = name;
            this.value = value;
        }

        public Boolean isTrue() {
            System.debug(this.name +  ' is ' + this.value);
            return this.value;
        }

        public String getName() {
            return this.name;
        }
    }
}