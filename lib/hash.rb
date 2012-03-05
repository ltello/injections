class Hash

  # Returns a copy of self recursivelly eliminating all blank? values
  # Examples:
  #    {}.compact #=> nil
  #    {:one=>1, :two=>2, :three=>{:thirtyone=>31}}.compact                  #=> {:one => 1, :two => 2, :three => {:thirtyone => 31}}
  #    {:one=>1, :two=>2, :three=>{:thirtyone=>31, :nothing=>""}}.compact    #=> {:one => 1, :two => 2, :three => {:thirtyone => 31}}
  #    {:one=>1, :two=>2, :three=>{:thirtyone=>31, :nothing=>[]}}.compact    #=> {:one => 1, :two => 2, :three => {:thirtyone => 31}}
  #    {:one=>1, :two=>[2, nil]}.compact                                     #=> {:one => 1, :two => [2]}
  def compact
    self.inject(self.class.new) do |result, ele|
      key, value = e
      new_value = value.compact
      new_value.present? ? result.merge(key => new_value) : result
    end.presence || self.class.new
  end

  # The bang mate of compact
  def compact!
    each do |key, value|
      value.compact!
      delete(key) if value.blank?
    end
  end

  # Returns an array of strings where each string is a different path to the deeper values (leaves) of the hash
  # excluding the leaves
  # Ex:
  #     {:hello => {:mark  => 'knopfler',
  #                 :peter => 'gabriel'}}.expand  #=> ['hello_mark', 'hello_peter']
  # I've used it sometimes from I18n keys.
  def expand
    map do |key, value|
      right = case value
                when Hash
                  value.expand
                when Array
                  Array(value.join('_'))
                else
                  [nil]
              end
      [key].product(right).map {|pair| pair.compact.join('_')}
    end.flatten
  end


  # Returns an array of strings where each string is a different path to the deeper values (leaves) of the hash
  # Ex:
  #     {:hello => {:mark  => 'knopfler',
  #                 :peter => 'gabriel'}}.expand  #=> ['hello_mark_knopfler', 'hello_peter_gabriel']
  # I've used it sometimes from I18n keys.
  def expand_with_leaves
    map do |key, value|
      right = case value
                when Hash
                  value.expand
                when Array
                  Array(value.join('_'))
                else
                  Array(value.to_s)
              end
      [key].product(right).map {|pair| pair.join('_')}
    end.flatten
  end
end
