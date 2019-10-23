require 'product'
require 'product_pack'
require 'bakery_builder'
require 'bakery'


require 'order'
require 'order_parser'
require 'delivery'
require 'byebug'

describe Order do
  let(:bakery)     { Bakery.default      }
  subject(:order)  { described_class.new(bakery) }

  let(:croissant)  { bakery.inventory['CF'][:product] }
  let(:muffin)     { bakery.inventory['MB11'][:product] }



  describe '#find_delivery' do
    it "should return correct delivery" do
      order.add_product(muffin, 2)
      delivery = order.find_delivery

      expect(delivery.pack_sets.size).to eq(1)
    end

    it "should return nil for orders impossible to fulfill" do
      order.add_product(muffin, 3)
      delivery = order.find_delivery

      expect(delivery).to be_nil
    end

  end
end