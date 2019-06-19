# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::CodeConverter::ToPrefixForm
  # @since 0.1.0
  extend Forwardable

  class << self
    # @param program [String]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def call(program)
      new(program).call
    end
  end

  # @since 0.1.0
  def_delegators Jaina::Parser::Expression, :terminal?, :non_terminal?

  # @param program [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(program)
    @program = program.dup.tap(&:freeze)
    @postfix_form = Jaina::Parser::CodeConverter::ToPostfixForm.call(@program)
    @tokens = Jaina::Parser::Tokenizer.tokenize(@postfix_form)
  end

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def call
    to_prefix_form
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
  attr_reader :postfix_form

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :tokens

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def to_prefix_form
    token_series = tokens.map(&:dup)
    expression_stack = []

    until token_series.empty?
      current_token = token_series.shift

      case
      when terminal?(current_token)
        process_terminal_token(current_token, expression_stack)
      when non_terminal?(current_token)
        process_non_terminal_token(current_token, expression_stack)
      end
    end

    # NOTE: build prefixed program string
    Jaina::Parser::Tokenizer.join(expression_stack)
  end

  # @param current_token [String]
  # @param expression_stack [Array<String>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def process_terminal_token(current_token, expression_stack)
    expression_stack.push(current_token)
  end

  # @param current_token [String]
  # @param expression_stack [Array<String>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def process_non_terminal_token(current_token, expression_stack)
    expression = Jaina::Parser::Expression.fetch(current_token)

    case # TODO: dry
    when expression.acts_as_binary_term?
      first_operand  = expression_stack.pop
      second_operand = expression_stack.pop

      prefixed_expression_parts = [expression.token, second_operand, first_operand]
      prefixed_expression = Jaina::Parser::Tokenizer.join(prefixed_expression_parts)

      expression_stack.push(prefixed_expression)
    when expression.acts_as_unary_term?
      operand = expression_stack.pop

      prefixed_expression_parts = [expression.token, operand]
      prefixed_expression = Jaina::Parser::Tokenizer.join(prefixed_expression_parts)

      expression_stack.push(prefixed_expression)
    end
  end
end
