# frozen_string_literal: true

module Jaina::Parser::Expression::Operator
  # @api private
  # @since 0.1.0
  class Not < NonTerminal
    precedence_level 4
    associativity_direction :right
    token 'NOT'
    acts_as_unary_term

    # @param context [Jaina::Parser::AST::Context]
    # @return [Any]
    #
    # @api private
    # @since 0.2.0
    def evaluate(context)
      !expression.evaluate(context)
    end

    # @return [Jaina::Parser::Expression::Operator::Abstract]
    #
    # @api private
    # @since 0.2.0
    def expression
      expressions.first
    end
  end
end
