require 'product'

describe ProductPack do
  let(:product)      { Product.new('MF', 'Muffin') }
  let(:product_pack) { described_class.new(product, 5, 9.99) }

  describe '#code' do
    subject { product_pack.product }
    it { is_expected.to eq(product) }
  end

  describe '#size' do
    subject { product_pack.size }
    it { is_expected.to eq(5) }
  end

  describe '#price' do
    subject { product_pack.price }
    it { is_expected.to eq(9.99) }
  end
end
