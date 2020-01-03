require 'spec_helper'

RSpec.describe Procedure::Outcome do
  subject(:outcome) { described_class.new(step_classes) }

  let(:passed_step) { build_step_class(passed: true) }
  let(:failed_step) { build_step_class(passed: false) }
  let(:step_classes) { [FakePassedClass, FakeFailedClass] }

  context 'passing procedure' do
    it 'passes procedure when all steps were executed successfuly' do
      2.times { outcome.add(passed_step) }

      expect(outcome).to be_positive
    end

    it 'does not pass procedure when not yet all steps were executed' do
      outcome.add(passed_step)

      expect(outcome).not_to be_positive
    end

    it 'does not pass procedure when one of steps failed' do
      outcome.add(passed_step)
      outcome.add(failed_step)

      expect(outcome).not_to be_positive
    end
  end

  context 'aborting procedure' do
    it 'aborts procedure when failed step is detected' do
      outcome.add(failed_step)

      expect(outcome).to be_failure
    end

    it 'does not abort procedure when failed step was not detected' do
      outcome.add(passed_step)

      expect(outcome).not_to be_failure
    end
  end

  def build_step_class(passed:)
    double(passed?: passed)
  end

  class FakePassedClass; end
  class FakeFailedClass; end
end
