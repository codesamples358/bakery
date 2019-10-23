class PackFinder
  class Optimized < FullSearch
    def dead_end?
      @best_pack_set && 
        @pack_set.pack_count >= @best_pack_set.pack_count
    end

    def possible_pack_counts(pack_idx)
      @yet_to_add     = @qty - @pack_set.product_count
      @max_pack_count = @yet_to_add / @packs[pack_idx].size

      if @best_pack_set
        max_to_best     = @best_pack_set.pack_count - @pack_set.pack_count
        @max_pack_count = max_to_best if max_to_best < @max_pack_count
      end

      if pack_idx == @packs.size - 1
        possible_last_pack_counts
      else
        @max_pack_count.downto(0)
      end
    end

    def possible_last_pack_counts
      pack_size = @packs[-1].size
      # only one pack type left to adjust, 
      # so it either exactly divides the number products yet to add or not

      if @yet_to_add % pack_size == 0
        exact_pack_count = @yet_to_add / pack_size
        exact_pack_count <= @max_pack_count ? [ exact_pack_count ] : [ ]
      else
        [ ]
      end
    end

    # def set_as_best
    #   super
      
    #   counts = @pack_set.counts
    #   zero_idx = counts.index(0)
      
    #   if !zero_idx || counts[zero_idx + 1 .. -1].all? {|count| count == 0}
    #     best_found!
    #   end
    # end
  end
end