module Procedure
  module Step
    def self.included(target)
      target.send(:include, InstanceMethods)
      target.extend ClassMethods
    end

    module ClassMethods
      def passed?(context = {})
        fake_open_struct = Struct.new(*context.keys).new(*context.values)

        new(fake_open_struct).passed?
      end
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
