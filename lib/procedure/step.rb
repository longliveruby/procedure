module Procedure
  module Step
    def self.included(target)
      target.send(:include, InstanceMethods)
      target.extend ClassMethods
    end

    module ClassMethods
    end

    module InstanceMethods
      def initialize(context)
        @context = context
      end

      def failure_message; end
      def failure_code; end

      private
      attr_reader :context
    end
  end
end
