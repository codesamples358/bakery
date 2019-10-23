require 'product'
require 'product_pack'
require 'bakery_builder'
require 'bakery'


require 'order'
require 'order_parser'
require 'byebug'

describe OrderParser do
  let(:bakery)     { Bakery.default      }
  subject(:parser) { described_class.new(bakery) }

  let(:croissant)  { bakery.inventory['CF'][:product] }
  let(:muffin)     { bakery.inventory['MB11'][:product] }

  describe '#parse' do
    it 'should parse one-line valid order' do
      order = parser.parse("10 CF")

      order.products.size.should equal(1)
      order.products[croissant].should equal(10)
    end  

    it 'should raise exception for wrong product codes' do
      expect { parser.parse("10 LOL") }
        .to raise_exception(OrderParser::InvalidProduct)
    end

    [ "slfkj", "", "\n", "10 CF s", "10" ].each do |line|

      it "should raise InvalidFormat exception for line '#{line}'" do
        expect { parser.parse(line) }
          .to raise_exception(OrderParser::InvalidFormat)
      end

    end

    [ "3.14", "-8", "0" ].each do |q|

      it "should raise InvalidQuantity for non-natural quantity '#{q}'" do
        expect { parser.parse("#{q} CF") }
          .to raise_exception(OrderParser::InvalidQuantity)
      end

    end


    it "should raise exception if any line is invalid" do
      expect { parser.parse("10 CF\ndkfj") }
        .to raise_exception(OrderParser::InvalidFormat)
    end

    it 'should parse two-line valid order' do
      order = parser.parse("10 CF\n5 MB11")

      order.products.size.should equal(2)

      order.products[croissant].should equal(10)
      order.products[muffin].should equal(5)
    end  

    it 'should raise exception for wrong product codes' do
      expect { parser.parse("10 CF\n5 CF") }
        .to raise_exception(Order::DuplicateProduct)
    end
  end
end