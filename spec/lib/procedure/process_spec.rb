require 'spec_helper'

RSpec.describe Procedure::Process do
  subject { described_class.new(context, steps) }

  class FakeStepOne
    include Procedure::Step

    def passed?
      true
    end
  end

  class FakeStepTwo
    include Procedure::Step

    def passed?
      true
    end
  end

  class FakeStepThree
    include Procedure::Step

    def passed?
      false
    end
  end

  let(:context) do
    Struct.new(:first_name, :last_name).new('John', 'Doe')
  end

  describe '#passed_steps' do
    context 'when all steps are passed' do
      let(:steps) { [FakeStepOne, FakeStepTwo] }

      it 'returns all steps' do
        subject.call(false)

        expect(subject.passed_steps).to eq(["FakeStepOne", "FakeStepTwo"])
      end
    end

    context 'when one of the steps failed' do
      let(:steps) { [FakeStepOne, FakeStepThree, FakeStepTwo] }

      it 'returns only passed steps if fail_fast option is true' do
        subject.call(true)

        expect(subject.passed_steps).to eq(["FakeStepOne"])
      end

      it 'returns all passed steps if fail_fast option is false' do
        subject.call(false)

        expect(subject.passed_steps).to eq(["FakeStepOne", "FakeStepTwo"])
      end
    end
  end

  describe '#call' do
    context 'when one of steps failed' do
      let(:steps) { [FakeStepOne, FakeStepThree, FakeStepTwo] }

      it 'does not call steps after failure if fail_fast option is true' do
        expect(FakeStepTwo).not_to receive(:new)

        subject.call(true)
      end

      it 'calls steps after failure if fail_fast option is false' do
        expect(FakeStepTwo).to receive(:new).and_call_original

        subject.call(false)
      end
    end

    context 'when all steps passed' do
      let(:steps) { [FakeStepOne, FakeStepTwo] }

      it 'calls all steps' do
        expect(FakeStepOne).to receive(:new).and_call_original
        expect(FakeStepTwo).to receive(:new).and_call_original

        subject.call(true)
      end
    end
  end

  describe '#passed?' do
    context 'when all steps passed' do
      let(:steps) { [FakeStepOne, FakeStepTwo] }

      it 'returns true' do
        subject.call(true)

        expect(subject).to be_success
      end
    end

    context 'when one of steps failed' do
      let(:steps) { [FakeStepOne, FakeStepThree] }

      it 'returns false' do
        subject.call(true)

        expect(subject).not_to be_success
      end
    end
  end
end
