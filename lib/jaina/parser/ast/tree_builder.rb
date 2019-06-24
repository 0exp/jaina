# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::AST::TreeBuilder
  # @since 0.1.0
  extend Forwardable

  class << self
    # @param program [String]
    # @return [Jaina::Parser::AST::Tree]
    #
    # @api private
    # @since 0.1.0
    def build(program)
      new(program).build
    end
  end

  # @since 0.1.0
  def_delegators Jaina::Parser::Expression,
                 :terminal?,
                 :non_terminal?,
                 :acts_as_unary_term?,
                 :acts_as_binary_term?

  # @param progrm [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(program)
    @program = program.dup.tap(&:freeze)
    @prefix_form = Jaina::Parser::CodeConverter.to_prefix_form(@program)
    @tokens = Jaina::Parser::Tokenizer.tokenize(@prefix_form)
  end

  # @return [Jaina::Parser::AST:Tree]
  #
  # @api private
  # @since 0.1.0
  def build
    token_series = tokens.map(&:dup)
    expression_tree = build_expression_tree(token_series)

    Jaina::Parser::AST::Tree.new(
      initial_program: program,
      ast_oriented_program: prefix_form,
      expression: expression_tree
    )
  end

  private

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :program

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :prefix_form

  # @return [Array<Jaina::Parser::Tokenizer::Token>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :tokens

  # @param token_series [Array<Jaina::Parser::Tokenizer::Token>]
  # @return [Array<Jaina::Parser::Expression::Operator::Abstract>]
  #
  # @api private
  # @since 0.1.0
  def build_expression_tree(token_series)
    current_token = extract_second_token(token_series)
    return if current_token.nil?

    case
    when terminal?(current_token.token)
      build_terminal_expression(current_token)
    when non_terminal?(current_token.token)
      build_non_terminal_expression(current_token, token_series)
    end
  end

  # @param token_series [Array<Jaina::Parser::Tokenizer::Token>]
  # @return [String, NilClass]
  #
  # @api private
  # @since 0.1.0
  def extract_second_token(token_series)
    token_series.shift
  end

  # @param current_token [Jaina::Parser::Tokenizer::Token]
  # @return [Jaina::Parser::Expression::Operator::Abstract]
  #
  # @api private
  # @since 0.1.0
  def build_terminal_expression(current_token)
    Jaina::Parser::Expression.build(current_token)
  end

  # @param current_token [Jaina::Parser::Tokenizer::Token]
  # @param token_series [Array<Jaina::Parser::Tokenizer::Token>]
  # @return [Jaina::Parser::Expression::Operator::Abstract]
  #
  # @api private
  # @since 0.1.0
  def build_non_terminal_expression(current_token, token_series)
    case
    when acts_as_unary_term?(current_token.token)
      Jaina::Parser::Expression.build(
        current_token,
        build_expression_tree(token_series)
      )
    when acts_as_binary_term?(current_token.token)
      Jaina::Parser::Expression.build(
        current_token,
        build_expression_tree(token_series),
        build_expression_tree(token_series)
      )
    end
  end
end
