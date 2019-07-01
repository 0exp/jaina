# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::Expression::Registry
  require_relative './registry/access_interface_mixin'

  # @since 0.1.0
  Error = Class.new(StandardError)
  # @since 0.1.0
  AlreadyRegisteredExpressionError = Class.new(Error)
  # @since 0.1.0
  UnregisteredExpressionError = Class.new(Error)
  # @since 0.1.0
  IncorrectExpressionObjectError = Class.new(Error)

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @expression_set = {}
    @access_lock = Mutex.new
  end

  # @param expression_token [String]
  # @return [Class{Jaina::Parser::Unit::Abstract}]
  #
  # @api private
  # @since 0.1.0
  def [](expression_token)
    thread_safe { fetch(expression_token) }
  end

  # @param expression [Class{Jaina::Parser::Unit::Abstract}]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register(expression)
    thread_safe { add(expression) }
  end

  # @param expression [Class{Jaina::Parser::Unit::Abstract}]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def redefine(expression)
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

  # @return [Hash<String,Class{Jaina::Parser::Unit::Abstract}>]
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

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def expression_names
    expression_set.keys
  end

  # @param expression [Class{Jaina::Parser::Unit::Abstract}]
  # @return [void]
  #
  # @raise [Jaina::Parser::Expression::Registry::AlreadyRegisteredExpressionError]
  # @raise [Jaina::Parser::Expression::Registry::IncorrectExpressionObjectError]
  #
  # @api private
  # @since 0.5.0
  def add(expression)
    raise(
      IncorrectExpressionObjectError,
      'Expression should be a subtype of Jaina::Parser::Expression::Operation::Abstract'
    ) unless expression.is_a?(Class) && expression < Jaina::Parser::Expression::Unit::Abstract

    raise(
      AlreadyRegisteredExpressionError,
      "Expression with token `#{expression.token}` already exist"
    ) if registered?(expression.token)

    expression_set[expression.token] = expression
  end

  # @param expression [Class{Jaina::Parser::Unit::Abstract}]
  # @return [void]
  #
  # @raise [Jaina::Parser::Expression::Registry::IncorrectExpressionObjectError]
  #
  # @api private
  # @since 0.5.0
  def apply(expression)
    raise(
      IncorrectExpressionObjectError,
      'Expression should be a subtype of Jaina::Parser::Expression::Operation::Abstract'
    ) unless expression.is_a?(Class) && expression < Jaina::Parser::Expression::Unit::Abstract

    expression_set[expression.token] = expression
  end

  # @param expression_token [String]
  # @return [Class{Jaina::Parser::Unit::Abstract}]
  #
  # @raise [Jaina::Parser::Expression::Registry::UnregisteredExpressionError]
  #
  # @api private
  # @since 0.1.0
  def fetch(expression_token)
    raise(
      UnregisteredExpressionError,
      "Expression with token `#{expression_token}` is not registered"
    ) unless registered?(expression_token)

    expression_set[expression_token]
  end
end
