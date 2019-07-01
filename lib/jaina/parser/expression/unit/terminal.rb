# frozen_string_literal: true

module Jaina::Parser::Expression::Unit
  # @api private
  # @since 0.1.0
  class Terminal < Abstract
    class << self
      # @return [Boolean]
      #
      # @api private
      # @since 0.1.0
      def terminal?
        true
      end

      # @return [Boolean]
      #
      # @api private
      # @since 0.1.0
      def non_temrinal?
        false
      end
    end
  end
end
