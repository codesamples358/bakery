require 'optparse'

require_relative '../lib/product'
require_relative '../lib/product_pack'

require_relative '../lib/bakery'
require_relative '../lib/bakery_builder'

require_relative '../lib/order'
require_relative '../lib/order_parser'
require_relative '../lib/delivery'

require_relative '../lib/pack_set'
require_relative '../lib/pack_finder'


class PackSet
  def ==(other)
    @counts == other.counts
  end
end

if false
  bakery   = Bakery.default
  codes = %w(MB11 CF VS5)
else
  bakery = BakeryBuilder.new({ 'Vegemite Scroll' =>  ['VS5',  
    {
      14 => 9.99,
      11 => 8.99,
      2  => 1.0
    }
  ]}).make

  codes = %w(VS5)
end

PackFinder::TIME_LIMIT = 100000

codes.each do |code|
  product = bakery.product_with_code(code)

  (1 .. 200).each do |qty|
    # puts "#{qty} - #{product.code}"
    putc '.'
    # finder = PackFinder::First.new(bakery, product, qty)
    finder       = PackFinder::Optimized.new(bakery, product, qty)
    best_finder  = PackFinder::FullSearch.new(bakery, product, qty)

    p1 = finder.solve
    p2 = best_finder.solve

    if p1 != p2
      puts "#{product} found pack is not the best when #{qty} products ordered"
      
      puts "Found: #{p1}"
      puts "Best:  #{p2}"    
    end
  end
end