require 'product'

describe Product do
  let(:product) { described_class.new('MF', 'Muffin') }

  describe '#code' do
    subject { product.code }

    it { is_expected.to eq('MF') }
  end

  describe '#name' do
    subject { product.name }

    it { is_expected.to eq('Muffin') }
  end
end
