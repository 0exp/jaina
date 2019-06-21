# frozen_string_literal: true

# @api public
# @since 0.1.0
class Jaina::Parser::AST::Context
  # @since 0.1.0
  Error = Class.new(StandardError)
  # @since 0.1.0
  UndefinedContextKeyError = Class.new(Error)

  # @param initial_context [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(**initial_context)
    @data = {}.merge!(initial_context)
    @access_lock = Mutex.new
  end

  # @param key [Any]
  # @param value [Any]
  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def set(key, value)
    thread_safe { apply(key, value) }
  end

  # @param key [Any]
  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def get(key)
    thread_safe { fetch(key) }
  end

  # @return [Array<Any>]
  #
  # @api public
  # @since 0.1.0
  def keys
    thread_safe { registered_data }
  end

  private

  # @return [Hash<Any,Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :data

  # @return [Mutex]
  #
  # @api private
  # @since 0.1.0
  attr_reader :access_lock

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    access_lock.synchronize { yield }
  end

  # @param key [Any]
  # @param value [Any]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def apply(key, value)
    value.tap { data[key] = value }
  end

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.1.0
  def registered_data
    data.keys
  end

  # @param key [String]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def fetch(key)
    data.fetch(key)
  rescue KeyError
    raise UndefinedContextKeyError, "Data with `#{key}` key does not exist"
  end
end
