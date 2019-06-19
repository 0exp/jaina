# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::AST::Tree
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :initial_program

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :ast_oriented_program

  # @return [Jaina::Parser::Expression::Operator::Abstract]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expression

  # @param initial_program [String]
  # @param expression [Jaina::Parser::Expression::Operator::Abstract]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(initial_program:, ast_oriented_program:, expression:)
    @initial_program = initial_program
    @ast_oriented_program = ast_oriented_program
    @expression = expression
  end
end
