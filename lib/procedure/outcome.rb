module Procedure
  class Outcome
    def initialize(step_classes)
      @step_classes = step_classes
      @failed_steps = []
      @passed_steps = []
    end

    def add(step)
      if step.passed?
        @passed_steps << step
      else
        @failed_steps << step
      end
    end

    def failure_messages
      return [] unless failure?

      @failed_steps.map(&:failure_message)
    end

    def failure_codes
      return [] unless failure?

      @failed_steps.map(&:failure_code)
    end

    def failure?
      @failed_steps.size.positive?
    end

    def positive?
      @failed_steps.size.zero? && @step_classes.size == @passed_steps.size
    end

    def passed_steps
      @passed_steps.map { |step| step.class.name }
    end
  end
end
