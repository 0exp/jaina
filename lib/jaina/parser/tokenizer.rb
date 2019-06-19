# frozen_string_literal: true

# @api private
# @since 0.1.0
module Jaina::Parser::Tokenizer
  # @return [Regexp]
  #
  # @api private
  # @since 0.1.0
  TOKEN_SCAN_PATTERN = /\(|\)|[\w\.\*]+/.freeze

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  TOKEN_SPLITTER = ' '

  class << self
    # @param program [String]
    # @return [Array<String>]
    #
    # @api private
    # @since 0.1.0
    def tokenize(program)
      program.scan(TOKEN_SCAN_PATTERN)
    end

    # @param tokens [Array<String>]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def join(tokens)
      tokens.join(TOKEN_SPLITTER)
    end
  end
end
