# Injections: A collection of methods injected in different classes I like to use in my Rails applications

* **ActionController:**
    _before_render: A callback executed just after an action in a controller before rendering any view

* **ActiveResource:**
    _ACTIVE_RESOURCE_MAPPING_CLASSES: a mechanism to map an ActiveResource class to a ActiveRecord class of different name

* **Array:**
    _pop_if_unique: the single element of the array if it is of size 1.

* **FalseClass:**
    _to_i: 0.

* **Hash:**
    _compact: a copy of the hash with blank? values removed recursivelly
    _compact!: the bang mate of compact
    _expand: array of strings of the different paths of a hash excluding end values.
    _expand_with_leaves: same as _expand including end values.

* **Numeric:**
    _force: forces the numeric to be included in a range.

* **Object:**
    _sendonil: calls a method in the object but dont raise an exception if is nil or not respond_to?.
    _sendoself: same as sendonil but returns self instead of raising an exception.
    _msend: like send but it also accepts a method's chain.
    _first_responder: returns the first method of a list that object responds to.
    _altsend: the result of calling first_responder method to the object.
    _respond_to_all?: whether the object responds to all the methods of a list.
    _blanko0?: whether the object is blank? or 0

* **String:**
    _stringify: wrap a string into single or double quotes.
    _max_included_number: maximum number scanned in a string.

* **TrueClass:**
    _to_i: 1.






