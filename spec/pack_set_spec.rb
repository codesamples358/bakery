require 'product'
require 'product_pack'
require 'bakery_builder'
require 'bakery'


require 'order'
require 'order_parser'
require 'delivery'
require 'byebug'

describe PackSet do
  let(:muffin)       { Product.new('MF', 'Muffin') }

  subject(:pack_set) { 
    packs = []
    packs << ProductPack.new(muffin, 2,   3.99)
    packs << ProductPack.new(muffin, 10, 16.95)

    pack_set = PackSet.new(muffin, packs, [2, 1])
  }

  describe '#product_count' do
    it "should return total number of items inside the pack set" do
      expect(pack_set.product_count).to eq(14)
    end
  end

  describe '#pack_count' do
    it "should return total number of packs inside the pack set" do
      expect(pack_set.pack_count).to eq(3)
    end
  end

  describe '#total_price' do
    it "should return total price of the pack set" do
      price = 2 * 3.99 + 1 * 16.95
      price = BigDecimal.new(price, 4)

      expect(pack_set.total_price).to eq(price)
    end
  end

  describe '#counts_by_size' do
    it "should return total price of the pack set" do
      expect(pack_set.counts_by_size).to eq({2 => 2, 10 => 1})
    end
  end

  describe "#to_s" do
    it "should return string representation" do
      expect(pack_set.to_s).to eq("14 MF $24.93\n  2 x 2 $3.99\n  1 x 10 $16.95")
    end
  end
end