class Object

  # Returns the result of calling a method in the receiver or nil if either the receiver is nil or the
  # method is not defined for the receiver. This way, no exeptions are raised and we can do things like this:
  #
  # if person && person.surname           # can be substituted by:
  # if person.sendonil(:surname)
  #
  # l = params[:id].length if params[:id].present? && params[:id].respond_to?(:length)
  # l = params[:id].sendonil(:length)
  #
  # Ex:
  #   r.sendonil(:surname, 2)
  # If r == nil                   #=> nil and not raises exception
  # If r.surname is not defined   #=> nil and not raises exception
  # If r.surname(2) is defined    #=> r.surname(2)
  def sendonil(meth, *args, &block)
    send(meth, *args, &block) if respond_to?(meth)
  end

  # Same as sendonil but returns the receiver instead of nil
  def sendoself(meth, *args, &block)
    respond_to?(meth) ? send(meth, *args, &block) : self
  end

  # Multiple send: Send the chain of methods in the string <chain> to the receiver.
  # This method exists because send can only accept one method name to be applied to the receiver.
  # Ex:
  #   obj.msend('name.underscore') #=> obj.name.underscore
  def msend(chain, opts={})
    chain.split('.').inject(self, :send) rescue (opts[:raise_error] ? raise : nil)
  end

  # Alternative send: Try to call methods, one by one until self respond_to one of them
  # Otherwise returns an error: last methodname NotFound in self.
  def altsend(*methods)
    send(first_responder(*methods) || methods.last)
  end

  # Given an array of method names (symbols), returns the first for which self responds to if any.
  # Otherwise, returns false
  def respond_to_any?(*methods)
    !!(methods.find {|meth| self.respond_to?(meth)})
  end

  # Given an array of method names (symbols), returns the first for which self responds to if any.
  # Otherwise, returns false
  def first_responder(*methods)
    methods.find {|meth| self.respond_to?(meth)}
  end

  # Given an array of method names(symbols or strings), returns true if self respond_to? all of them.
  # Otherwise, returns false
  def respond_to_all?(*methods)
    methods.all? {|meth| self.respond_to?(meth)}
  end

  # Only to be redefined in some classes and not get an error in the rest.
  def compact
    self
  end

  # Only to be redefined in some classes and not get an error in the rest.
  def compact!
    self
  end

  # Check whether self is blank or 0
  def blanko0?
    self.blank? or self == 0
  end

  # Converts param to a Date instance if it's a string or leave it unmodified if it's already of type Date or DateTime
  # Otherwise returns nil.
  def ensure_date_type(param)
    return param if [Date, DateTime].include?(param)
    param.to_date if param.is_a?(String)
  end

end
