class ProductPack
  attr_reader :product, :size, :price

  def initialize(product, size, price)
    @product = product
    @size    = size
    @price   = price
  end
end