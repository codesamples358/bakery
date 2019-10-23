require 'product'
require 'product_pack'
require 'bakery_builder'
require 'bakery'

describe Bakery do
  subject(:bakery) { described_class.new }
  
  let(:muffin) { Product.new('MF', 'Muffin') }
  let(:bun)    { Product.new('BN', 'Bun') }

  describe '#add_product_type' do
    it 'raises an exception if the type is invalid' do
      expect { bakery.add_product_type([1, 2, 3]) }
        .to raise_exception(Bakery::InvalidProduct)
    end

    it 'does not allow products with duplicate codes' do
      bakery.add_product_type(muffin)

      expect { bakery.add_product_type(muffin) }
        .to raise_exception(Bakery::DuplicateProductType)
    end

    it 'allows products with different names' do
      bakery.add_product_type(muffin)
      expect { bakery.add_product_type(bun) }.to_not raise_exception
    end
  end

  describe '#add_product_pack' do
    it "doesn't allow to add pack types for absent products" do
      expect { bakery.add_product_pack(muffin, 1, 9.99) }
        .to raise_exception(Bakery::MissingProduct)
    end

    it "allows to add pack types for existent products" do
      bakery.add_product_type(muffin)

      expect { bakery.add_product_pack(muffin, 1, 9.99) }
        .to_not raise_exception

      packs = bakery.product_packs(muffin) 
      expect(packs.size).to eq(1)
      pack = packs.first

      expect(pack.size).to eq(1)
      expect(pack.price).to eq(9.99)
    end

    it "doesn't allow to add duplicate pack sizes" do
      bakery.add_product_type(muffin)
      bakery.add_product_pack(muffin, 1, 9.99)

      expect { bakery.add_product_pack(muffin, 1, 8.99) }
        .to raise_exception(Bakery::DuplicatePackSize)
    end
  end

  describe '.default' do
    let(:default_bakery) { Bakery.default }

    it 'should be instantiated' do
      expect { default_bakery }.to_not raise_exception
    end
  end
end
