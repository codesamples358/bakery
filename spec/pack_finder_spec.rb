require 'product'
require 'product_pack'
require 'bakery_builder'
require 'bakery'

require 'pack_set'
require 'pack_finder'


describe PackFinder do
  describe '#solve' do
    def pack_prices(size_to_price)
      spec = { 'Cake' => [
        'C', 
        size_to_price
      ]}

      @bakery  = BakeryBuilder.new(spec).make
      @product = @bakery.inventory['C'][:product]
    end

    def find_pack_set(qty)
      pack_finder  = PackFinder.create(@bakery, @product, qty)
      @pack_set    = pack_finder.solve
    end

    def pack_counts(qty)
      @ordered_quantity = qty
      pack_set = find_pack_set(qty)
      pack_set.counts_by_size if pack_set
    end

    (1 .. 3).each do |qty|
      it "should give #{qty} packs of 1 when #{qty} pieces are ordered, in case if only packs of 1 are in stock" do
        pack_prices( 1 => 1.0 )
        pack_counts(qty).should == { 1 => qty }
      end
    end

    it "should minimize number of packs even if there are less expensive alternatives" do
      pack_prices(1 => 1.0, 2 => 100.0 )
      pack_counts(2).should == {2 => 1}
    end

    it "should minimize number of packs" do
      pack_prices(14 => 9.99, 11 => 8.99, 2  => 1.0)
      pack_counts(22).should == {11 => 2}
    end

    it "should return nil if there're no possible pack set to fulfill an order" do
      pack_prices( 2 => 1 )
      find_pack_set(1).should be_nil
    end

    def various_prices
      [
        { 1 => 1.0 },
        { 2 => 2.0, 3 => 2.5, 5 => 4.0 }
      ]
    end

    it "should return pack set with total number of products exactly equal to that being ordered" do
      qty = 74
      pack_prices(2 => 2.0, 3 => 2.5, 5 => 4.0)
      pack_set = find_pack_set(qty)
      pack_set.product_count.should eq(qty)
    end

    it "should not stall the worker in unsolvable cases" do
      pack_prices(2 => 1.0, 4 => 2.0, 6 => 3.0, 8 => 4.0, 10 => 5.0)
      PackFinder::TIME_LIMIT = 0.1
      
      expect {
        find_pack_set(7598432570293847502983471)
      }.to raise_exception(PackFinder::TimeoutException)
    end
  end
end
