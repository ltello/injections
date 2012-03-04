class Hash

  # Returns a copy of self recursivelly eliminating all blank? values
  # Examples:
  #    {}.compact #=> nil
  #    {:one=>1, :two=>2, :three=>{:thirtyone=>31}}.compact                  #=> {:one => 1, :two => 2, :three => {:thrirtyone => 31}}
  #    {:one=>1, :two=>2, :three=>{:thirtyone=>31, :nothing=>""}}.compact    #=> {:one => 1, :two => 2, :three => {:thrirtyone => 31}}
  #    {:one=>1, :two=>2, :three=>{:thirtyone=>31, :nothing=>[]}}.compact    #=> {:one => 1, :two => 2, :three => {:thrirtyone => 31}}
  #    {:one=>1, :two=>[2, nil]}.compact                                     #=> {:one => 1, :two => [2]}
  def compact
    self.inject(self.class.new) do |acc, e|
      k, v = e
      newv = v.compact
      newv.present? ? acc.merge(k => newv) : acc
    end.presence || self.class.new
  end

  def compact!
    each do |k, v|
      v.compact!
      delete(k) if v.blank?
    end
  end

  # Returns an array of strings where each string is a different path to the deeper values (leaves) of the hash
  # Ex:
  #     {:hello => {:mark  => 3,
  #                 :peter => 5}}.expand  #=> ['hello_mark', 'hello_peter']
  def expand
    map do |k, v|
      right = case v
                when Hash
                  v.expand
                when Array
                  Array(v.join('_'))
                else
                  [nil]
              end
      [k].product(right).map {|a| a.compact.join('_')}
    end.flatten
  end


  # Returns an array of strings where each string is a different path to the deeper values (leaves) of the hash
  # Ex:
  #     {:hello => {:mark  => 3,
  #                :peter => 5}}.expand  #=> ['hello_mark_3', 'hello_peter_5']
  def expand_with_leaves
    map do |k, v|
      right = case v
                when Hash
                  v.expand
                when Array
                  Array(v.join('_'))
                else
                  Array(v.to_s)
              end
      [k].product(right).map {|a| a.join('_')}
    end.flatten
  end
end
