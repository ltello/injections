class Array

  # If the array contains a single element, returns that element (not an array), otherwise return the array itself.
  def pop_if_unique
    size == 1 ? first : self
  end

end
