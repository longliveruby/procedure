module Procedure
  module Organizer
    def self.included(target)
      target.send(:include, InstanceMethods)
      target.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :step_classes

      def steps(*step_classes)
        @step_classes = step_classes
      end

      def call(context = {})
        params = { execution_time: Time.now }.merge(context)
        fake_open_struct = Struct.new(*params.keys).new(*params.values)

        Procedure::Process.new(fake_open_struct, @step_classes).tap do |process|
          process.call
        end
      end
    end

    module InstanceMethods
    end
  end
end
