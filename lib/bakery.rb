require_relative 'extensions/array'

class Bakery
  InvalidProduct       = Class.new(StandardError)
  DuplicateProductType = Class.new(StandardError)
  DuplicatePackSize    = Class.new(StandardError)
  InvalidPackSize      = Class.new(StandardError)
  InvalidPackPrice     = Class.new(StandardError)
  MissingProduct       = Class.new(StandardError)

  attr_accessor :inventory

  def initialize
    @inventory = {}
  end

  def add_product_type(product)
    raise(InvalidProduct, product) unless product.instance_of?(Product)

    raise(DuplicateProductType, "Bakery already has product type: #{product.code}") if
      @inventory.key?(product.code)

    @inventory[product.code] = {
      product: product,
      packs: []
    }
  end

  def add_product_pack(product, size, price)
    raise(InvalidPackSize, size) unless size.is_a?(Numeric) && size > 0
    raise(InvalidPackPrice, price) unless price.is_a?(Numeric) && price > 0
    packs = product_packs(product)

    if packs.any? {|pack| pack.size == size }
      raise(DuplicatePackSize, size)
    end

    packs << ProductPack.new(product, size, price)
  end

  def product_packs(product)
    raise(MissingProduct, product) unless @inventory.key?(product.code)
    @inventory[product.code][:packs]
  end

  def product_with_code(code)
    if entry = @inventory[code]
      entry[:product]
    end
  end

  def self.default
    BakeryBuilder.default.make
  end
end
