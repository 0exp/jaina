# frozen_string_literal: true

# @api private
# @since 0.4.0
class Jaina::Parser::Tokenizer::TokenBuilder
  require_relative './token_builder/argument_type_caster'

  # @return [Regexp]
  #
  # @api private
  # @since 0.4.0
  PARTS_SPLITTER = /[^,\[\]]+|\[|\]+/.freeze

  # @return [String]
  #
  # @api private
  # @since 0.4.0
  OPENING_ATTRIBUTE_GROUP_SYMBOL = '['

  # @return [String]
  #
  # @api private
  # @since 0.4.0
  CLOSING_ATTRIBUTE_GROUP_SYMBOL = ']'

  # @since 0.4.0
  Error = Class.new(StandardError)
  # @since 0.4.0
  IncorrectTokenDefinitionError = Class.new(Error)

  class << self
    # @param raw_token [String]
    # @return [Jaina::Parser::Tokenizer::Token]
    #
    # @api private
    # @since 0.4.0
    def build(raw_token)
      new(raw_token).build
    end
  end

  # @param raw_token [String]
  # @return [void]
  #
  # @api private
  # @since 0.4.0
  def initialize(raw_token)
    @raw_token = raw_token
    @parts = raw_token.scan(PARTS_SPLITTER)
  end

  # @return [Jaina::Parser::Tokenizer::Token]
  #
  # @api private
  # @since 0.4.0
  def build
    check_for_correctness!

    # NOTE:
    #   format: token[attr1,attr2,attr3]
    #     TOKEN => parts[0]
    #     OPENING BRAKET => parts[1]
    #     CLOSING BRAKET => parts[-1]
    #     ARGUMENTS => parts[2..-2]
    token = parts[0]
    arguments = parts.count.zero? ? [] : parts[2..-2]
    arguments = ArgumentTypeCaster.cast(*arguments)

    Jaina::Parser::Tokenizer::Token.new(raw_token, token, *arguments)
  end

  private

  # @return [String]
  #
  # @api private
  # @since 0.4.0
  attr_reader :raw_token

  # @return [Array<String>]
  #
  # @api private
  # @since 0.4.0
  attr_reader :parts

  # @return [void]
  #
  # @api private
  # @since 0.4.0
  def check_for_correctness! # rubocop:disable Metrics/AbcSize
    # NOTE: parts array contains a token only
    return if parts.count == 1

    # NOTE: prats should contain at least: "__token__", "[", and "]"
    raise(
      IncorrectTokenDefinitionError,
      "Incorrect token definition `#{raw_token}`: " \
      "token should contain `[` and `]` if `[` is provided"
    ) if parts.count < 3

    # NOTE:
    #   format: token [ attr1 attr2 attr3 ]
    #     TOKEN => parts[0]
    #     OPENING BRAKET => parts[1]
    #     CLOSING BRAKET => parts[-1]
    #     ARGUMENTS => parts[2..-2]

    opening_corner  = parts[1]
    closing_corner  = parts[-1]
    arguments       = parts[2..-2]

    # rubocop:disable Metrics/LineLength
    if arguments.include?(OPENING_ATTRIBUTE_GROUP_SYMBOL) || opening_corner != OPENING_ATTRIBUTE_GROUP_SYMBOL
      raise(
        IncorrectTokenDefinitionError,
        "Incorrect token definition `#{raw_token}`: `[` should be the first arguments opening symbol."
      )
    end

    if arguments.include?(CLOSING_ATTRIBUTE_GROUP_SYMBOL) || closing_corner != CLOSING_ATTRIBUTE_GROUP_SYMBOL
      raise(
        IncorrectTokenDefinitionError,
        "Incorrect token definition `#{raw_token}`: `]` should be the last arguments closing symbol."
      )
    end
    # rubocop:enable Metrics/LineLength
  end
end
