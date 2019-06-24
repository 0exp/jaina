# frozen_string_literal: true

# @api private
# @since 0.1.0
module Jaina::Parser::Expression
  require_relative './expression/operator'
  require_relative './expression/registry'

  # @since 0.1.0
  include Registry::AccessInterfaceMixin

  # @since 0.1.0
  register(Operator::And)
  # @since 0.1.0
  register(Operator::Not)
  # @since 0.1.0
  register(Operator::Or)
  # @since 0.1.0
  register(Operator::LeftCorner)
  # @since 0.1.0
  register(Operator::RightCorner)

  class << self
    # @param expression_token [Jaina::Parser::Tokenizer::Token]
    # @param arguments [Array<Any>]
    # @return [Jaina::Parser::Expression::Operator::Abstract]
    #
    # @api private
    # @since 0.1.0
    def build(expression_token, *expression_arguments)
      expression = fetch(expression_token.token)
      expression.new(arguments: expression_token.arguments, expressions: expression_arguments)
    end

    # @param expression_token [String]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def terminal?(expression_token)
      fetch(expression_token).terminal?
    end

    # @param expression_token [String]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def non_terminal?(expression_token)
      fetch(expression_token).non_terminal?
    end

    # @param expression_token [String]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def group_opener?(expression_token)
      fetch(expression_token).acts_as_group_opener?
    end

    # @param expression_token [String]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def group_closener?(expression_token)
      fetch(expression_token).acts_as_group_closener?
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def acts_as_binary_term?(expression_token)
      fetch(expression_token).acts_as_binary_term?
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def acts_as_unary_term?(expression_token)
      fetch(expression_token).acts_as_unary_term?
    rescue => error
      binding.pry
    end
  end
end
