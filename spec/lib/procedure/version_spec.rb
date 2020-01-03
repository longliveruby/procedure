require 'spec_helper'

RSpec.describe Procedure::Version do
  describe '.to_s' do
    it 'returns current gem version' do
      expect(described_class.to_s).to eq('0.0.1')
    end
  end
end
