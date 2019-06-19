# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::Expression::Operator::Abstract
  require_relative './abstract/dsl'

  # @since 0.1.0
  include DSL
  # @since 0.1.0
  Error = Class.new(StandardError)
  # @since 0.1.0
  InompatibleDirectionComparisonError = Class.new(Error)

  class << self
    # @param another_operator [Class<Jaina::Parser::Expression::Operator::Abstract>]
    # @return [Boolean]
    #
    # @raise [InompatibleDirectionComparisonError]
    #
    # @api private
    # @since 0.1.0
    def lower?(another_operator)
      raise(
        InompatibleDirectionComparisonError,
        "Trying to compare non-comparable terms `#{token}` and `#{another_operator.token}`"
      ) if associativity_direction.nil? || another_operator.associativity_direction.nil?

      if associativity_direction == Jaina::Parser::Expression::Operator::Abstract::DSL::LEFT_ASSOC
        associativity_direction <= another_operator.associativity_direction
      else
        associativity_direction < another_operator.associativity_direction
      end
    end
  end

  # @return [Array<Jaina::Parser::Expressions::Operator::Abstract>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expressions

  # @param expressions [Array<Jaina::Parser::Expression::Operator::Abstract>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(*expressions)
    @expressions = expressions
  end

  # @param context [Any]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def evaluate; end

  # @param another_operator [Class<Jaina::Parser::Expression::Operator::Abstract>]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def lower(another_operator)
    self.class.lower(another_operator)
  end
end
