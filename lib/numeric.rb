class Numeric

  # Forces self to be included in the range composed by <low>, <high> params.
  # Conditions: high must be greater then low. If not is the case, high will be set to low.
  #   If self is < low, returns low
  #   If self === (low..high) returns self
  #   If self is > high, returns high
  #   This method is equivalent to: [[self, high].min, 1].max
  def force(low, high)
    high = low if high < low
    [low, self, high].sort[1]
  end

end
