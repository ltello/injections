# Injections: A collection of methods injected in different classes I like to use in my Rails applications
____
* **ActionController:**

    **before\_render:** _A callback executed just after an action in a controller before rendering any view._
____

* **ActiveResource:**

    **ACTIVE\_RESOURCE\_MAPPING\_CLASSES:** _a mechanism to map an ActiveResource class to a ActiveRecord class of different name._
____
* **Array:**

    **pop\_if\_unique:** _the single element of the array if it is of size 1._
____
* **FalseClass:**

    **to\_i:** _0._
____
* **Hash:**

    **compact:** _a copy of the hash with blank? values removed recursively_

    **compact!:** _the bang mate of compact._

    **expand:** _array of strings of the different paths of a hash excluding end values._

    **expand\_with\_leaves:** _same as_ expand _including end values._
____
* **Numeric:**

    **force:** _forces the numeric to be included in a range._
____
* **Object:**

    **sendonil:** _calls a method in the object but dont raise an exception if is nil or not respond_to?._

    **sendoself:** _same as sendonil but returns self instead of raising an exception._

    **msend:** like _send but it also accepts a method's chain._

    **first\_responder:** _returns the first method of a list that object responds to._

    **altsend:** _the result of calling first_responder method to the object._

    **respond_to_all?:** _whether the object responds to all the methods of a list._

    **blanko0?:** _whether the object is blank? or 0._
____
* **String:**

    **stringify:** _wrap a string into single or double quotes._

    **max\_included\_number:** _maximum number scanned in a string._
____
* **TrueClass:**

    **to\_i:** _1._






