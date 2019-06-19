# frozen_string_literal: true

module Jaina::Parser::Expression::Operator
  # @api private
  # @since 0.1.0
  class LeftCorner < Grouping
    acts_as_group_opener
    token '('
  end
end
