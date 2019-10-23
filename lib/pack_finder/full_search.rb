class PackFinder
  class FullSearch
    attr_reader :best_pack_set
    
    def initialize(bakery, product, qty)
      @bakery  = bakery
      @product = product
      @qty     = qty

      @packs   = bakery.product_packs(@product).sort_by(&:size).reverse
      @size    = @packs.size
    end

    def solve
      @start = Time.now
      @best_pack_set = nil

      catch(:best_found) { start_search }
      
      @best_pack_set
    end

    def start_search
      initial_pack_counts = Array.new(@packs.size, 0)
      search_packs(initial_pack_counts, 0)
    end

    def search_packs(pack_counts, pack_idx)
      raise TimeoutException if Time.now - @start > TIME_LIMIT
      @pack_set = PackSet.new(@product, @packs, pack_counts)

      return if dead_end?
      check_best_pack
      throw(:best_found) if best_found?

      return if pack_idx >= @packs.size

      possible_pack_counts(pack_idx).each do |c|
        new_counts = pack_counts.dup
        new_counts[pack_idx] = c

        search_packs(new_counts, pack_idx + 1)
      end
    end

    def dead_end?
      false
    end

    def possible_pack_counts(pack_idx)
      max_pack_count = (@qty - @pack_set.product_count) / @packs[pack_idx].size
      max_pack_count.downto(0)
    end

    def check_best_pack
      if @pack_set.product_count == @qty
        if !@best_pack_set || @pack_set.pack_count < @best_pack_set.pack_count 
          set_as_best
        end
      end
    end

    def set_as_best
      @best_pack_set = @pack_set
    end

    def best_found!
      @best_pack_found = true
    end

    def best_found?
      @best_pack_found
    end
  end
end