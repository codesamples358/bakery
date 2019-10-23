require 'bigdecimal'

class BakeryBuilder
  DEFAULT = {
    'Vegemite Scroll' =>  ['VS5', 
                           { 3 => 6.99,
                             5 => 8.99 }
    ],

    'Blueberry Muffin' => ['MB11', 
                           { 2 => 9.95,
                             5 => 16.95,
                             8 => 24.95 }
    ],                            

    'Croissant'        => ['CF', 
                           { 3 => 5.95,
                             5 => 9.95,
                             9 => 16.99 }
    ]
  }

  def initialize(spec)
    @spec = spec
  end

  def self.default
    new(DEFAULT)
  end

  def make
    Bakery.new.tap { |bakery| build bakery }
  end

  def build(bakery)
    @spec.each do |name, spec_entry|
      code, packs = spec_entry
      product     = Product.new(code, name)

      bakery.add_product_type(product)

      packs.each do |size, price|
        bakery.add_product_pack(product, size, BigDecimal.new(price.to_s))        
      end
    end
  end
end