# frozen_string_literal: true

describe 'Smoke test' do
  specify do
    # NOTE: create new expressions
    a = Class.new(Jaina::TerminalExpr) { token 'A' }
    b = Class.new(Jaina::TerminalExpr) { token 'B' }
    c = Class.new(Jaina::TerminalExpr) { token 'C' }
    d = Class.new(Jaina::TerminalExpr) { token 'D' }
    e = Class.new(Jaina::TerminalExpr) { token 'E' }
    x = Class.new(Jaina::TerminalExpr) { token 'X' }

    # NOTE: register expressions
    Jaina.register_expression(a)
    Jaina.register_expression(b)
    Jaina.register_expression(c)
    Jaina.register_expression(d)
    Jaina.register_expression(e)
    Jaina.register_expression(x)

    # NOTE: parse basic operators and new registered expressions
    ast = Jaina.parse('(A AND B) OR C AND (E OR D)')
    expect(ast.ast_tree.ast_oriented_program).to eq('AND OR AND A B C OR E D')

    # NOTE: parse basic operators and new registered expressions (with NOT-operand)
    ast = Jaina.parse('(A AND B) OR C AND (E OR D) AND (NOT C)')
    expect(ast.ast_tree.ast_oriented_program).to eq('AND AND OR AND A B C OR E D NOT C')

    # NOTE: parse with attributes
    ast = Jaina.parse('(A[1,2] AND B[3,4] OR C AND (E[asdf] OR D)')
    expect(ast.ast_tree.ast_oriented_program).to eq('AND OR AND A[1,2] B[3,4] C OR E[asdf] D')

    # NOTE: get registered expression names
    expect(Jaina.expressions).to contain_exactly(
      'A', 'B', 'C', 'D', 'E', 'AND', 'OR', 'NOT', '(', ')', 'X'
    )

    # NOTE: fetch new registered expression
    expect(Jaina.fetch_expression('A')).to eq(a)
    expect(Jaina.fetch_expression('B')).to eq(b)
    expect(Jaina.fetch_expression('C')).to eq(c)
    expect(Jaina.fetch_expression('D')).to eq(d)
    expect(Jaina.fetch_expression('E')).to eq(e)
    expect(Jaina.fetch_expression('X')).to eq(x)

    # NOTE: fetch core expressions
    expect(Jaina.fetch_expression('AND')).to eq(Jaina::Parser::Expression::Operator::And)
    expect(Jaina.fetch_expression('OR')).to  eq(Jaina::Parser::Expression::Operator::Or)
    expect(Jaina.fetch_expression('NOT')).to eq(Jaina::Parser::Expression::Operator::Not)
    expect(Jaina.fetch_expression('(')).to   eq(Jaina::Parser::Expression::Operator::LeftCorner)
    expect(Jaina.fetch_expression(')')).to   eq(Jaina::Parser::Expression::Operator::RightCorner)

    # NOTE: redefine expression
    x_new = Class.new(Jaina::TerminalExpr) { token 'X' }
    Jaina.redefine_expression(x_new)
    expect(Jaina.fetch_expression('X')).to eq(x_new)

    # NOTE: fail on unregistered expression
    expect { Jaina.fetch_expression('KEK') }.to raise_error(
      Jaina::Parser::Expression::Registry::UnregisteredExpressionError
    )

    # NOTE: fail on "trying to register alredy registered exception"
    expect { Jaina.register_expression(a) }.to raise_error(
      Jaina::Parser::Expression::Registry::AlreadyRegisteredExpressionError
    )

    # NOTE: fail on "trying to register an incorrect object as an expression"
    expect { Jaina.register_expression(123) }.to raise_error(
      Jaina::Parser::Expression::Registry::IncorrectExpressionObjectError
    )

    # NOTE: fail on "trying to redefine expression with incorrect object"
    expect { Jaina.redefine_expression(123) }.to raise_error(
      Jaina::Parser::Expression::Registry::IncorrectExpressionObjectError
    )

    # NOTE: fail on unexpected tokens
    expect { Jaina.parse('A AND KEK') }.to raise_error(
      Jaina::Parser::Expression::Registry::UnregisteredExpressionError
    )

    # NOTE: fail on incorrect attribute syntax
    expect { Jaina.parse('A][') }.to raise_error(
      Jaina::Parser::Tokenizer::TokenBuilder::IncorrectTokenDefinitionError
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
        context.get(:current_value) > 0
      end
    end

    # step 3: create third operand
    init_state = Class.new(Jaina::TerminalExpr) do
      token 'INIT'

      def evaluate(context)
        initial_value = arguments[0] || 0 # NOTE: support for arguments

        context.set(:current_value, initial_value)
      end
    end

    # step 4: register new oeprands
    Jaina.register_expression(add_number)
    Jaina.register_expression(check_number)
    Jaina.register_expression(init_state)

    # step 5: run your program

    # NOTE: with initial context
    expect(Jaina.evaluate('CHECK AND ADD', current_value: -1)).to eq(false)
    expect(Jaina.evaluate('CHECK AND ADD', current_value: 2)).to eq(12)
    # NOTE: without initial context
    expect(Jaina.evaluate('INIT AND ADD')).to eq(10)
    expect(Jaina.evaluate('INIT[100] AND (CHECK AND ADD)')).to eq(110)

    expect(Jaina.evaluate('NOT CHECK AND ADD', current_value: -1)).to eq(9)
    expect(Jaina.evaluate('NOT CHECK', current_value: -1)).to eq(true)

    # NOTE: fail on incorrect context usage (when the required context key does not exist)
    expect { Jaina.evaluate('CHECK') }.to raise_error(
      Jaina::Parser::AST::Context::UndefinedContextKeyError
    )
  end
end
