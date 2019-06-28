# frozen_string_literal: true

# @api private
# @since 0.1.0
module Jaina::Parser::Tokenizer
  require_relative './tokenizer/token'
  require_relative './tokenizer/token_builder'

  # @return [Regexp]
  #
  # @api private
  # @since 0.1.0
  TOKEN_SCAN_PATTERN = /\(|\)|[\<\=\-\>\:\"\'\.\,\w\[\]]+/.freeze

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  TOKEN_SPLITTER = ' '

  class << self
    # @param program [String]
    # @return [Array<Jaina::Parser::Tokenizer::Token>]
    #
    # @api private
    # @since 0.1.0
    def tokenize(program)
      program.scan(TOKEN_SCAN_PATTERN).map do |raw_token|
        TokenBuilder.build(raw_token)
      end
    end

    # @param tokens [Array<Jaina::Parser::Tokenizer::Token>]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def join(tokens)
      raw_join(tokens.map(&:raw_token))
    end

    # @param raw_tokens [Array<String>]
    # @return [String]
    #
    # @api private
    # @since 0.4.0
    def raw_join(raw_tokens)
      raw_tokens.join(TOKEN_SPLITTER)
    end
  end
end
