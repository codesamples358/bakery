class Array
  def sum
    inject(0) { |sum, x| sum + x }
  end
end