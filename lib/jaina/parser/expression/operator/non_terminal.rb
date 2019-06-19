# frozen_string_literal: true

module Jaina::Parser::Expression::Operator
  # @api private
  # @since 0.1.0
  class NonTerminal < Abstract
    class << self
      # @return [Boolean]
      #
      # @api private
      # @since 0.1.0
      def terminal?
        false
      end

      # @return [Boolean]
      #
      # @api private
      # @since 0.1.0
      def non_terminal?
        true
      end
    end
  end
end
