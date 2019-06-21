# frozen_string_literal: true

describe 'Smoke test' do
  specify do
    # NOTE: create new expressions
    a = Class.new(Jaina::TerminalExpr) { token 'A' }
    b = Class.new(Jaina::TerminalExpr) { token 'B' }
    c = Class.new(Jaina::TerminalExpr) { token 'C' }
    d = Class.new(Jaina::TerminalExpr) { token 'D' }
    e = Class.new(Jaina::TerminalExpr) { token 'E' }

    # NOTE: register expressions
    Jaina.register_expression(a)
    Jaina.register_expression(b)
    Jaina.register_expression(c)
    Jaina.register_expression(d)
    Jaina.register_expression(e)

    # NOTE: parse basic operators and new registered expressions
    ast = Jaina.parse('(A AND B) OR C AND (E OR D)')
    expect(ast.ast_tree.ast_oriented_program).to eq('AND OR AND A B C OR E D')

    # NOTE: parse basic operators and new registered expressions (with NOT-operand)
    ast = Jaina.parse('(A AND B) OR C AND (E OR D) AND (NOT C)')
    expect(ast.ast_tree.ast_oriented_program).to eq('AND AND OR AND A B C OR E D NOT C')

    # NOTE: get registered expression names
    expect(Jaina.expressions).to contain_exactly(
      'A', 'B', 'C', 'D', 'E', 'AND', 'OR', 'NOT', '(', ')'
    )

    # NOTE: fetch new registered expression
    expect(Jaina.fetch_expression('A')).to eq(a)
    expect(Jaina.fetch_expression('B')).to eq(b)
    expect(Jaina.fetch_expression('C')).to eq(c)
    expect(Jaina.fetch_expression('D')).to eq(d)
    expect(Jaina.fetch_expression('E')).to eq(e)

    # NOTE: fetch core expressions
    expect(Jaina.fetch_expression('AND')).to eq(Jaina::Parser::Expression::Operator::And)
    expect(Jaina.fetch_expression('OR')).to  eq(Jaina::Parser::Expression::Operator::Or)
    expect(Jaina.fetch_expression('NOT')).to eq(Jaina::Parser::Expression::Operator::Not)
    expect(Jaina.fetch_expression('(')).to   eq(Jaina::Parser::Expression::Operator::LeftCorner)
    expect(Jaina.fetch_expression(')')).to   eq(Jaina::Parser::Expression::Operator::RightCorner)

    # NOTE: fail on unregistered expression
    expect { Jaina.fetch_expression('KEK') }.to raise_error(
      Jaina::Parser::Expression::Registry::UnregisteredExpressionError
    )

    # NOTE: fail on unexpected tokens
    expect { Jaina.parse('A AND KEK') }.to raise_error(
      Jaina::Parser::Expression::Registry::UnregisteredExpressionError
    )

    # NOTE: new operand: returns true and sets 1 to the global AST context
    g = Class.new(Jaina::TerminalExpr) do
      token 'G'

      def evaluate(context)
        context.set(:g_expression, 1)
      end
    end
    Jaina.register_expression(g)

    # NOTE: new operand: sets (g_expression + 10)
    j = Class.new(Jaina::TerminalExpr) do
      token 'J'

      def evaluate(context)
        context.set(:g_expression, (context.get(:g_expression) + 10))
      end
    end
    Jaina.register_expression(j)

    # NOTE: evaluation
    expect(Jaina.evaluate('G AND J')).to eq(11)
    expect(Jaina.evaluate('G AND (J AND J) OR E')).to eq(21)
  end
end
