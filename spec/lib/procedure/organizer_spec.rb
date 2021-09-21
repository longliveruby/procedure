require 'spec_helper'

RSpec.describe Procedure::Organizer do
  let(:context) do
    {
      first_name: 'John'
    }
  end

  class FakePassedStepOne
    include Procedure::Step

    def passed?
      true
    end
  end

  class FakePassedStepTwo
    include Procedure::Step

    def passed?
      true
    end
  end

  class FakeFailedStepOne
    include Procedure::Step

    def passed?
      false
    end

    def failure_message
      "User #{context.first_name} is not valid"
    end

    def failure_code
      :user_not_valid
    end
  end

  class FakeFailedStepTwo
    include Procedure::Step

    def passed?
      false
    end

    def failure_message
      "User #{context.first_name} is too long"
    end

    def failure_code
      :user_first_name_too_long
    end
  end

  class FakePassedOrganizer
    include Procedure::Organizer

    steps FakePassedStepOne, FakePassedStepTwo
  end

  class FakeFailedOrganizer
    include Procedure::Organizer

    steps FakePassedStepOne, FakeFailedStepOne, FakePassedStepTwo, FakeFailedStepTwo
  end

  context 'when fail_fast option is passed' do
    it 'returns false outcome when procedure did not passed' do
      outcome = FakeFailedOrganizer.call(context: context)

      expect(outcome).not_to be_success
      expect(outcome.failure_messages).to eq(['User John is not valid'])
      expect(outcome.failure_codes).to eq([:user_not_valid])
    end
  end

  context 'when fail_fast option is not passed' do
    it 'returns false outcome when procedure did not passed' do
      outcome = FakeFailedOrganizer.call(context: context, options: { fail_fast: false })

      expect(outcome).not_to be_success
      expect(outcome.failure_messages).to eq(['User John is not valid', 'User John is too long'])
      expect(outcome.failure_codes).to eq([:user_not_valid, :user_first_name_too_long])
    end
  end

  it 'returns true outcome when procedure passed' do
    outcome = FakePassedOrganizer.call(context: context)

    expect(outcome).to be_success
  end
end
