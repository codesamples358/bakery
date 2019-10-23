class Order
  DuplicateProduct = Class.new(StandardError)
  InvalidQuantity  = Class.new(StandardError)

  attr_reader :products

  def initialize(bakery)
    @bakery   = bakery
    @products = {}
  end

  def add_product(product, qty)
    raise(DuplicateProduct) if @products.key?(product)
    raise(InvalidQuantity)  unless qty.is_a?(Fixnum) && qty > 0 

    @products[product] = qty
  end

  def find_delivery
    @delivery = Delivery.new(self)

    @products.each do |product, qty|
      finder = PackFinder.create(@bakery, product, qty)

      begin
        pack_set = finder.solve
        return nil unless pack_set
      rescue PackFinder::TimeoutException
        pack_set = finder.best_pack_set
        pack_set or raise
      end
      
      @delivery.add_pack_set(pack_set)
    end

    @delivery
  end
end