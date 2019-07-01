# frozen_string_literal: true

module Jaina::Parser::Expression::Unit
  # @api private
  # @since 0.1.0
  class Grouping < Abstract
    require_relative './grouping/dsl'

    # @since 0.1.0
    include DSL
  end
end
