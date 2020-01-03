module Procedure
  class Outcome
    def initialize(step_classes)
      @step_classes = step_classes
      @failed_step = nil
      @passed_steps = []
    end

    def add(step)
      if step.passed?
        @passed_steps << step
      else
        @failed_step = step
      end
    end

    def failure_message
      return unless failure?

      @failed_step.failure_message
    end

    def failure_code
      return unless failure?

      @failed_step.failure_code
    end

    def failure?
      !@failed_step.nil?
    end

    def positive?
      @failed_step.nil? && @step_classes.size == @passed_steps.size
    end

    def passed_steps
      @passed_steps.map { |step| step.class.name }
    end
  end
end
