# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::AST
  # @since 0.2.0
  extend Forwardable

  require_relative './ast/tree'
  require_relative './ast/tree_builder'
  require_relative './ast/evaluator'
  require_relative './ast/context'

  class << self
    # @param program [String] Program string in prefix form
    # @return [Jaina::Parser::AST]
    #
    # @api private
    # @since 0.1.0
    def build(program)
      ast_tree = Jaina::Parser::AST::TreeBuilder.build(program)
      new(program, ast_tree)
    end
  end

  # @return [Jaina::Pasrer::AST::Tree]
  #
  # @api private
  # @since 0.1.0
  attr_reader :ast_tree

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :program

  # @since 0.2.0
  def_delegator :ast_tree, :root

  # @param program [String]
  # @param ast_tree [Jaina::Parser::AST::Tree]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(program, ast_tree)
    @program  = program.dup.tap(&:freeze)
    @ast_tree = ast_tree
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def evaluate
    Jaina::Parser::AST::Evaluator.evaluate(self)
  end
end
