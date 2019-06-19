# frozen_string_literal: true

# @api public
# @since 0.1.0
module Jaina
  require_relative './jaina/version'
  require_relative './jaina/parser'

  # @since 0.1.0
  extend Forwardable

  TerminalExpr    = Parser::Expression::Operator::Terminal
  NonTerminalExpr = Parser::Expression::Operator::NonTerminal
  GroupingExpr    = Parser::Expression::Operator::Grouping

  class << self
    # @param program [String]
    # @return [Jaina::Parser::AST]
    #
    # @api public
    # @since 0.1.0
    def parse(program)
      Parser.parse(program)
    end

    # @param program [String]
    # @return [Any]
    #
    # @api public
    # @since 0.1.0
    def evaluate(program)
      parse(program).evaluate
    end

    # @param expression_klass [Class{Jaina::Parser::Expression::Operator::Abstract}]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def register_expression(expression_klass)
      Jaina::Parser::Expression.register(expression_klass)
    end

    # @return [Array<String>]
    #
    # @api public
    # @since 0.1.0
    def expressions
      Jaina::Parser::Expression.expressions
    end

    # @param expression_token [String]
    # @return [Class{Jaina::Parser::Expressions::Operator::Abstract}]
    #
    # @api public
    # @since 0.1.0
    def fetch_expression(expression_token)
      Jaina::Parser::Expression.fetch(expression_token)
    end
    alias_method :[], :fetch_expression
  end
end
