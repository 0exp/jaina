# frozen_string_literal: true

# @api private
# @since 0.1.0
module Jaina::Parser::Expression::Unit::Abstract::DSL
  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.instance_variable_set(:@acts_as_group_closener, false)
      base_klass.instance_variable_set(:@acts_as_group_opener, false)

      base_klass.extend ClassMethods
      base_klass.include InstanceMethods
      base_klass.singleton_class.prepend(ClassInheritance)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassInheritance
    # @param child_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inherited(child_klass)
      child_klass.instance_variable_set(
        :@acts_as_group_opener,
        instance_variable_get(:@acts_as_group_opener)
      )

      child_klass.instance_variable_set(
        :@acts_as_group_closener,
        instance_variable_get(:@acts_as_group_closener)
      )

      super
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def acts_as_group_closener
      @acts_as_group_closener = true
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def acts_as_group_opener
      @acts_as_group_opener = true
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def acts_as_group_closener?
      @acts_as_group_closener
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def acts_as_group_opener?
      @acts_as_group_opener
    end
  end

  # @api private
  # @since 0.1.0
  module InstanceMethods
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def acts_as_group_closener?
      self.class.acts_as_group_closener?
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def acts_as_group_opener?
      self.class.acts_as_group_opener?
    end
  end
end
