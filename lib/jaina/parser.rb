# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser
  require_relative './parser/expression'
  require_relative './parser/tokenizer'
  require_relative './parser/code_converter'
  require_relative './parser/ast'

  class << self
    # @param program [String]
    # @return [Jaina::Parser::AST]
    #
    # @api private
    # @since 0.1.0
    def parse(program)
      new(program).parse
    end
  end

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :program

  # @param program [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(program)
    @program = program.dup.tap(&:freeze)
  end

  # @return [Jaina::Parser::AST]
  #
  # @api private
  # @since 0.1.0
  def parse
    AST.build(program)
  end
end
