# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::Expressions::Operator
  require_relative './operator/abstract'
  require_relative './operator/non_erminal'
  require_relative './operator/terminal'
  require_relative './operator/and'
  require_relative './operator/or'
  require_relative './operator/not'
end
