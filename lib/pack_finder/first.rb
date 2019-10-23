class PackFinder
  class First < FullSearch
    def set_as_best
      super
      best_found!
    end
  end
end