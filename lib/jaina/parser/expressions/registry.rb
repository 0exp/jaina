# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::Expressions::Registry
  require_relative './registry/access_interface_mixin'

  # @since 0.1.0
  Error = Class.new(StandardError)
  # @since 0.1.0
  AlreadyRegisteredExpressionError = Class.new(Error)
  # @since 0.1.0
  UnregisteredExpressionError = Class.new(Error)
  # @since 0.1.0
  IncorrectEzpressionObjectError = Class.new(Error)

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @expression_set = {}
    @access_lock = Mutex.new
  end

  # @param expression_token [String]
  # @return [Jaina::Parser::Operator::Abstract]
  #
  # @api private
  # @since 0.1.0
  def [](expression_token)
    thread_safe { fetch(expression_token) }
  end

  # @param expression [Jaina::Parser::Operator::Abstract]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register(expression)
    thread_safe { apply(expression) }
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def expressions
    thread_safe { expression_names }
  end

  private

  # @return [Hash<String,Jaina::Parser::Operator::Abstract>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expression_set

  # @return [Mutex]
  #
  # @api private
  # @since 0.1.0
  attr_reader :access_lock

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def thread_safe
    access_lock.synchronize { yield if block_given? }
  end

  # @param expression_token [String]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def registered?(expression_token)
    expression_set.key?(expression_token)
  end

  # @param expression [Jaina::Parser::Operator::Abstract]
  # @return [void]
  #
  # @raise [Jaina::Parser::Expression::Registry::AlreadyRegisteredExpressionError]
  #
  # @api private
  # @since 0.1.0
  def apply(expression)
    raise(
      AlreadyRegisteredExpressionError,
      "Expression with token #{expression.token} already exist"
    ) if registered?(expression.token)

    raise(
      IncorrectEzpressionObjectError,
      'Expression should be a type of Jaina::Parser::Expression::Operation::Abstract'
    ) unless expression.is_a?(Jaina::Parser::Expression::Operation::Abstract)

    expression_set[exression_token] = expression
  end

  # @param expression_token [String]
  # @return [Jaina::Parser::Operator::Abstract]
  #
  # @raise [Jaina::Parser::Expression::Registry::UnregisteredExpressionError]
  #
  # @api private
  # @since 0.1.0
  def fetch(expression_token)
    raise(
      UnregisteredExpressionError,
      "Expression with token #{expression_token} is not registered"
    ) unless registered?(expression_token)

    expression_set[expression_token]
  end
end
