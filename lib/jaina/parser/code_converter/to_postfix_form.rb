# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::CodeConverter::ToPostfixForm
  # @api private
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
  def_delegators Jaina::Parser::Expression,
                 :non_terminal?,
                 :terminal?,
                 :group_opener?,
                 :group_closener?

  # @param program [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(program)
    @program = program.dup.tap(&:freeze)
    @tokens = Jaina::Parser::Tokenizer.tokenize(program)
  end

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def call
    to_postfix_form
  end

  private

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :program

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :tokens

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def to_postfix_form
    final_expression = []
    structure_operators = []
    token_series = tokens.map(&:dup)

    until token_series.empty?
      current_token = token_series.shift

      case
      when non_terminal?(current_token)
        process_non_terminal_token(final_expression, structure_operators, current_token)
      when group_opener?(current_token)
        process_group_opening_token(final_expression, structure_operators, current_token)
      when group_closener?(current_token)
        process_group_closing_token(final_expression, structure_operators, current_token)
      when terminal?(current_token)
        process_terminal_token(final_expression, structure_operators, current_token)
      end
    end

    finish_final_expression(final_expression, structure_operators, current_token)

    # NOTE: build postfixed program string
    Jaina::Parser::Tokenizer.join(final_expression)
  end

  # @param final_expression [Array<String>]
  # @param structure_operators [Array<String>]
  # @param current_token [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def process_non_terminal_token(final_expression, structure_operators, current_token)
    if structure_operators.any? # NOTE: check assocaitivity with potential next token
      potential_second_token = structure_operators.last

      if non_terminal?(potential_second_token)
        current_expression = Jaina::Parser::Expression.fetch(current_token)
        next_expression    = Jaina::Parser::Expression.fetch(potential_second_token)

        # NOTE: form infix to postfix form switching
        final_expression.push(structure_operators.pop) if current_expression.lower?(next_expression)
      end
    end

    structure_operators.push(current_token)
  end

  # @param final_expression [Array<String>]
  # @param structure_operators [Array<String>]
  # @param current_token [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def process_group_opening_token(final_expression, structure_operators, current_token)
    # NOTE: remember group opening operator
    structure_operators.push(current_token)
  end

  # @param final_expression [Array<String>]
  # @param structure_operators [Array<String>]
  # @param current_token [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def process_group_closing_token(final_expression, structure_operators, current_token)
    until group_opener?(structure_operators.last)
      # NOTE: push all tokens to the final expression
      final_expression.push(structure_operators.pop)
    end

    # NOTE: drop closing operator
    structure_operators.pop
  end

  # @param final_expression [Array<String>]
  # @param structure_operators [Array<String>]
  # @param current_token [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def process_terminal_token(final_expression, structure_operators, current_token)
    # NOTE: push terminal expression to the final expression
    final_expression.push(current_token)
  end

  # @param final_expression [Array<String>]
  # @param structure_operators [Array<String>]
  # @param current_token [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def finish_final_expression(final_expression, structure_operators, current_token)
    # NOTE: fill the rest tokens to the final expression
    until structure_operators.empty?
      final_expression.push(structure_operators.pop)
    end
  end
end
