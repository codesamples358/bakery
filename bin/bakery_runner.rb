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

bakery = Bakery.default

begin
  order = OrderParser.new(bakery).parse(ARGF.read)
rescue => e
  puts "Invalid Order: #{e}"
  exit
end

delivery = order.find_delivery rescue nil

if !delivery
  puts 'No option'
else
  puts delivery.to_s
end
