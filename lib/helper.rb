helpers do
  def cycle(values) # you can only have one cycle going at a time
    @count ||= 0
    @count = (@count + 1)%values.length
    values[@count-1]
  end
end