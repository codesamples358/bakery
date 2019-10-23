class PackFinder
  TIME_LIMIT = 10.0
  TimeoutException = Class.new(StandardError)
  DEFAULT_PACK_FINDER = :FullSearch

  def self.create(*args)
    const_name = ENV['pack_finder'] || DEFAULT_PACK_FINDER
    klass      = self.const_get(const_name)
    klass.new(*args)
  end
end

require_relative "pack_finder/full_search"
require_relative "pack_finder/first"
require_relative "pack_finder/optimized"