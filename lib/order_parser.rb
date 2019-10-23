class OrderParser
  ParseError      = Class.new(StandardError)

  InvalidQuantity = Class.new(ParseError)
  InvalidProduct  = Class.new(ParseError)
  InvalidFormat   = Class.new(ParseError)

  DuplicateProduct = Class.new(ParseError)

  def initialize(bakery)
    @bakery = bakery
    @order = Order.new(@bakery)
  end

  def parse(text)
    lines = text.split("\n") rescue (raise InvalidFormat)

    lines.each { |line| parse_line(line) }
    raise InvalidFormat if @order.products.size == 0

    @order
  end

  def parse_line(line)
    parts = line.split(/\s+/) rescue (raise InvalidFormat)

    if parts.size != 2
      raise InvalidFormat
    else
      qty, code = parts
      product   = find_product code
      qty       = parse_qty    qty

      @order.add_product( product, qty )
    end
  end

  def find_product(code)
    @bakery.product_with_code(code) or raise(InvalidProduct)
  end

  def parse_qty(string)
    raise InvalidQuantity unless string =~ /\A\d+\Z/

    qty = Integer(string) rescue (raise InvalidQuantity)
    raise InvalidQuantity unless qty > 0    
    qty
  end
end