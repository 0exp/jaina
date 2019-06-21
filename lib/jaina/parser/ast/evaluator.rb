# frozen_string_literal: true

# @api private
# @since 0.1.0
module Jaina::Parser::AST::Evaluator
  class << self
    # @param ast [Jaina::Parser::AST]
    # @return [Any]
    #
    # @api private
    # @since 0.1.0
    def evaluate(ast)
      # NOTE: build shared context for a program
      context = Jaina::Parser::AST::Context.new

      # NOTE: evaluate the root expression of AST
      # NOTE: root is an atity of type [Jaina::Parser::Expression::Operator::Abstract]
      ast.root.evaluate(context)
    end
  end
end
