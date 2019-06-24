# frozen_string_literal: true

# @api private
# @since 0.4.0
module Jaina::Parser::Tokenizer::TokenBuilder::ArgumentTypeCaster
  # @return [Regexp]
  #
  # @api private
  # @since 0.4.0
  INTEGER_PATTERN = /\A\d+\z/.freeze

  # @return [Regexp]
  #
  # @api private
  # @since 0.4.0
  FLOAT_PATTERN = /\A\d+\.\d+\z/.freeze

  # @return [Regexp]
  #
  # @api private
  # @since 0.4.0
  TRUE_PATTERN = /\A(t|true)\z/i.freeze

  # @return [Regexp]
  #
  # @api private
  # @since 0.4.0
  FALSE_PATTERN = /\A(f|false)\z/i.freeze

  # @return [Regexp]
  #
  # @api private
  # @since 0.4.0
  ARRAY_PATTERN = /\A[^'"].*\s*,\s*.*[^'"]\z/.freeze

  # @return [Regexp]
  #
  # @api private
  # @since 0.4.0
  QUOTED_STRING_PATTERN = /\A['"].*['"]\z/.freeze

  class << self
    # @param arguments [Array<String>]
    # @return [Array<Any>]
    #
    # @api private
    # @since 0.4.0
    def cast(*arguments)
      arguments.map { |argument| cast_argument_type(argument) }
    end

    private

    # @param value [String]
    # @return [Object]
    #
    # @api private
    # @since 0.4.0
    def cast_argument_type(value)
      case value
      when INTEGER_PATTERN
        Integer(value)
      when FLOAT_PATTERN
        Float(value)
      when TRUE_PATTERN
        true
      when FALSE_PATTERN
        false
      when ARRAY_PATTERN
        value.split(/\s*,\s*/).map(&method(:convert_argument))
      when QUOTED_STRING_PATTERN
        value.gsub(/(\A['"]|['"]\z)/, '')
      else
        value
      end
    end
  end
end
