# frozen_string_literal: true

# @api private
# @since 0.4.0
class Jaina::Parser::Tokenizer::Token
  # @return [String]
  #
  # @api private
  # @since 0.4.0
  attr_reader :raw_token

  # @return [String]
  #
  # @api private
  # @since 0.4.0
  attr_reader :token

  # @return [Array<String>]
  #
  # @api private
  # @since 0.4.0
  attr_reader :arguments

  # @param raw_token [String]
  # @param token [String]
  # @param arguments [Array<Any>]
  # @return [void]
  #
  # @api private
  # @since 0.4.0
  def initialize(raw_token, token, *arguments)
    @raw_token = raw_token
    @token = token
    @arguments = arguments
  end

  # @return [Jaina::Parser::Tokenizer::Token]
  #
  # @api private
  # @since 0.4.0
  def dup
    self.class.new(raw_token.dup, token.dup, *arguments.dup)
  end

  # @return [String]
  #
  # @api private
  # @since 0.4.0
  def to_s
    raw_token
  end
end
