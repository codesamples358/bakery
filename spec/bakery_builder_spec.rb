require 'product'
require 'product_pack'
require 'bakery_builder'
require 'bakery'

describe BakeryBuilder do
  describe '#make' do
    it 'builds a bakery with its product line & packs available' do
      builder = BakeryBuilder.new('Croissant' => ['CF', 
                                            { 1 => 1.99, 
                                              2 => 3.25 }
                        ]
      )

      bakery = builder.make

      product = bakery.product_with_code('CF')

      expect(product.code).to eq('CF')
      expect(product.name).to eq('Croissant')

      packs = bakery.product_packs(product)

      expect(packs.size).to eq(2)

      expect(packs[0].size).to eq(1)
      expect(packs[0].price).to eq(1.99)

      expect(packs[1].size).to eq(2)
      expect(packs[1].price).to eq(3.25)
    end
  end
end
