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
      context = Jaina::Parser::AST::Context.new
      # TODO: traverse the abstract syntax tree
    end
  end
end
