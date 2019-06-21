# frozen_string_literal: true

# @api private
# @since 0.1.0
module Jaina::Parser::AST::Evaluator
  class << self
    # @param initial_context [Hash<Symbol,Any>]
    # @param ast [Jaina::Parser::AST]
    # @return [Any]
    #
    # @api private
    # @since 0.1.0
    def evaluate(ast, **initial_context)
      # NOTE: build shared context for a program
      context = Jaina::Parser::AST::Context.new(**initial_context)

      # NOTE: evaluate the root expression of AST
      # NOTE: root is an entity of type [Jaina::Parser::Expression::Operator::Abstract]
      ast.root.evaluate(context)
    end
  end
end
