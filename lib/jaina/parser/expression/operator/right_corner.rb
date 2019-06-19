# frozen_string_literal: true

module Jaina::Parser::Expression::Operator
  # @api private
  # @since 0.1.0
  class RightCorner < Grouping
    acts_as_group_closener
    token ')'
  end
end
