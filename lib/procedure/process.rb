module Procedure
  class Process
    def initialize(context, steps)
      @context = context
      @steps = steps
      @passed = false
    end

    def success?
      outcome.positive?
    end

    def failure?
      !success?
    end

    def failure_message
      outcome.failure_message
    end

    def failure_code
      outcome.failure_code
    end

    def passed_steps
      outcome.passed_steps
    end

    def call
      @steps.each do |step_class|
        step = step_class.new(@context)
        outcome.add(step)

        break if outcome.failure?
      end
    end

    private

    def outcome
      @outcome ||= Procedure::Outcome.new(@steps)
    end
  end
end
