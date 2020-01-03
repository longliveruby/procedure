require 'spec_helper'

RSpec.describe Procedure::Step do
  class FakeStepClass
    include Procedure::Step
  end

  let(:context) { Struct.new(:name).new('John Doe') }

  it 'accepts context as an argument' do
    expect {
      FakeStepClass.new(context)
    }.not_to raise_error
  end
end
