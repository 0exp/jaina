# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::Expression::Unit::Abstract
  require_relative './abstract/dsl'

  # @since 0.1.0
  include DSL
  # @since 0.1.0
  Error = Class.new(StandardError)
  # @since 0.1.0
  InompatibleDirectionComparisonError = Class.new(Error)

  class << self
    # @param another_unit [Class<Jaina::Parser::Expression::Unit::Abstract>]
    # @return [Boolean]
    #
    # @raise [InompatibleDirectionComparisonError]
    #
    # @api private
    # @since 0.1.0
    def lower?(another_unit)
      raise(
        InompatibleDirectionComparisonError,
        "Trying to compare non-comparable terms `#{token}` and `#{another_unit.token}`"
      ) if associativity_direction.nil? || another_unit.associativity_direction.nil?

      if associativity_direction == Jaina::Parser::Expression::Unit::Abstract::DSL::LEFT_ASSOC
        associativity_direction <= another_unit.associativity_direction
      else
        associativity_direction < another_unit.associativity_direction
      end
    end
  end

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.4.0
  attr_reader :arguments

  # @return [Array<Jaina::Parser::Expressions::Unit::Abstract>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expressions

  # @option arguments [Array<Any>]
  # @option expressions [Array<Jaina::Parser::Expression::Unit::Abstract>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(arguments: [], expressions: [])
    @arguments   = arguments
    @expressions = expressions
  end

  # @param context [Any]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def evaluate(context); end

  # @param another_unit [Class<Jaina::Parser::Expression::Unit::Abstract>]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def lower(another_unit)
    self.class.lower(another_unit)
  end
end
