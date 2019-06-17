# frozen_string_literal: true

# @api private
# @since 0.1.0
module Jaina::Parser::Expressions
  require_relative './expressions/operator'
  require_relative './expressions/registry'

  # @since 0.1.0
  include Registry::AccessInterfaceMixin
end
