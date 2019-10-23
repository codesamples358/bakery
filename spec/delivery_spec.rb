require 'product'
require 'product_pack'
require 'bakery_builder'
require 'bakery'


require 'order'
require 'order_parser'
require 'delivery'
require 'byebug'

describe Delivery do
  let(:muffin)       { Product.new('MF', 'Muffin') }
  subject(:delivery) { described_class.new(nil) }

  describe '#to_s' do
    it "should return string correct string representation" do
      packs = []
      packs << ProductPack.new(muffin, 2,   3.99)
      packs << ProductPack.new(muffin, 10, 16.95)

      pack_set = PackSet.new(muffin, packs, [2, 1])

      delivery.add_pack_set(pack_set)
      str = "14 MF $24.93\n  2 x 2 $3.99\n  1 x 10 $16.95"

      expect(delivery.to_s).to eq(str)
    end
  end
end