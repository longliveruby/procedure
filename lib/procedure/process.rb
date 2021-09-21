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

    def failure_messages
      outcome.failure_messages
    end

    def failure_codes
      outcome.failure_codes
    end

    def passed_steps
      outcome.passed_steps
    end

    def call(fail_fast)
      @steps.each do |step_class|
        step = step_class.new(@context)
        outcome.add(step)

        break if outcome.failure? && fail_fast
      end
    end

    private

    def outcome
      @outcome ||= Procedure::Outcome.new(@steps)
    end
  end
end
