class PackSet
  attr_reader :counts

  def initialize(product, packs, counts)
    @product         = product
    @counts          = counts

    @packs_to_counts = packs.zip(counts).to_h
  end

  def product_count
    @product_count ||= @packs_to_counts
      .map {|pack, count| count * pack.size}
      .sum
  end

  def counts_by_size
    @packs_to_counts
      .map    { |pack, count| [pack.size, count] }
      .select { |size, count| count > 0          }
      .to_h
  end

  def pack_count
    @pack_count ||= @counts.sum
  end

  def total_price
    @packs_to_counts
      .map { |pack, count| count * pack.price }
      .sum
  end

  def format_price(price)
    sprintf("%.2f", price)
  end

  def to_s
    header = "#{product_count} #{@product.code} $#{format_price(total_price)}" 

    pack_lines = @packs_to_counts.map do |pack, count|
      "  #{count} x #{pack.size} $#{format_price(pack.price)}" if count > 0
    end

    [header, *pack_lines.compact].join("\n")
  end
end