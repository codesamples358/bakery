class Delivery
  attr_reader :pack_sets
  
  def initialize(order)
    @order = order
    @pack_sets = []
  end

  def add_pack_set(pack_set)
    @pack_sets << pack_set
  end

  def to_s
    @pack_sets.map(&:to_s).join("\n")
  end
end