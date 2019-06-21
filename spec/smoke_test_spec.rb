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

    # --- Full example ---

    # step 1: create first operand
    add_number = Class.new(Jaina::TerminalExpr) do
      token 'ADD'

      def evaluate(context)
        context.set(:current_value, context.get(:current_value) + 10)
      end
    end

    # step 2: create second operand
    check_number = Class.new(Jaina::TerminalExpr) do
      token 'CHECK'

      def evaluate(context)
        context.get(:current_value) < 0
      end
    end

    # step 3: create third operand
    init_state = Class.new(Jaina::TerminalExpr) do
      token 'INIT'

      def evaluate(context)
        context.set(:current_value, 0)
      end
    end

    # step 4: register new oeprands
    Jaina.register_expression(add_number)
    Jaina.register_expression(check_number)
    Jaina.register_expression(init_state)

    # step 5: run your program

    # NOTE: with initial context
    Jaina.evaluate('CHECK AND ADD', current_value: -1) # => false
    Jaina.evaluate('CHECK AND ADD', current_value: 2) # => 12
    # NOTE: without initial context
    Jaina.evaluate('INIT AND ADD') # => 10
    Jaina.evaluate('INIT AND (CHECK OR ADD)') # => 12

    # NOTE: fail on incorrect context usage (when the required context key does not exist)
    expect { Jaina.evaluate('CHECK') }.to raise_error(
      Jaina::Parser::AST::Context::UndefinedContextKeyError
    )
  end
end
