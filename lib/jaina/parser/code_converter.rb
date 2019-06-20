# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::CodeConverter
  require_relative './code_converter/to_postfix_form'
  require_relative './code_converter/to_prefix_form'

  class << self
    # @param program [String]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def to_postfix_form(program)
      ToPostfixForm.call(program)
    end

    # @param program [String]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def to_prefix_form(program)
      ToPrefixForm.call(program)
    end
  end
end
