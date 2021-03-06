# frozen_string_literal: true

module Jaina::Parser::Expression::Unit
  # @api private
  # @since 0.1.0
  class And < NonTerminal
    precedence_level 3
    associativity_direction :left
    token 'AND'
    acts_as_binary_term

    # @param context [Jaina::Parser::AST::Context]
    # @return [Any]
    #
    # @api private
    # @since 0.2.0
    def evaluate(context)
      left_expression.evaluate(context) && right_expression.evaluate(context)
    end

    # @return [Jaina::Parser::Expression::Unit::Abstract]
    #
    # @api private
    # @since 0.2.0
    def left_expression
      expressions[0]
    end

    # @return [Jaina::Parser::Expression::Unit::Abstract]
    #
    # @api private
    # @since 0.2.0
    def right_expression
      expressions[1]
    end
  end
end
