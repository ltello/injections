#encoding: utf-8

# Maps an ActiveResource class to a ActiveRecord class of different name
module Models
  module ArArMapping
    extend ActiveSupport::Concern

    # This constant must be defined in the ActiveResource base class to store the correspondences between
    # ActiveResource classes produced for this base class and ActiveRecord associated classes.
    # ACTIVE_RESOURCE_MAPPING = {'activeresource_klass_1' => 'ActiveRecord_klass_1', ... ,
    #                            'activeresource_klass_n' => 'ActiveRecord_klass_n'}

    # Also, in the ActiveRecord classes you must define a constant ACTIVE_RESOURCE_MAPPING_CLASSES to store
    # the actions to make de mapping effective:
    # Ex:
    #   class IncidenciaJudicialCivil < ActiveRecord::Base
    #
    #     # We ussually get remote data that match instances of this class
    #     # This constant defines the correspondence beetween those remotelly got ActiveResource classes and this class
    #     #   Ex: 'IncidenciasJudiciales::IncidenciasJuzgadoCivil::Incidencium' is the classname that ActiveResource
    #     #        gives to the instances associated to this class in the xml returned.
    #     #           :xml_path contains the path in the remote-xml returned to access the instances of this class.
    #     #           :special contains methodnames we'll define in :classname with body the string provided. This code
    #     #                    will get executed in the scope of the activeresource instance, not where the method is created.
    #     #           :exclude contains a list of attributes (from this class) we don't want to create methods to respond to.
    #     #           For all the rest of attributes of this class we'll create a correspondent method with body
    #     #             attributes[:attr], that is, the attribute value encountered in the activeresource instance.
    #     ACTIVE_RESOURCE_MAPPING_CLASSES = {'IncidenciasJudiciales::IncidenciasJuzgadoCivil::Incidencium' =>
    #                                         {:xml_path   => 'incidenciasJuzgadoCivil.incidencia',
    #                                          :attributes => {:special => {:date => "ensure_date_type(attributes[:date]) if !attributes[:date].is_a?(Date)",
    #                                                                       :actor => "attributes[:author]"},
    #                                                          :exclude => [:id, :company_id, :created_at, :updated_at]}}}


    module ClassMethods
      # Adapt activeresource class to respond to some methods of the associated activerecord class
      def map_activeresource_to_activerecord!(instances)
        return if instances.blank?
        Array.wrap(instances).each do |instance|
          activeresource_klass = instance.class
          unless activeresource_to_activerecord_class_mapped?(activeresource_klass)
            activerecord_klass = activerecord_class_of(activeresource_klass)
            force_activeresource_class_to_respond_to_activerecord_methods(activeresource_klass, activerecord_klass) if activerecord_klass
          end
        end
      end


      private

        # Returns the activerecord class associated to an activeresource_klass based in the mapping constant
        # ACTIVE_RESOURCE_MAPPING defined in the base ActiveResource class
        def activerecord_class_of(activeresource_klass)
          self::ACTIVE_RESOURCE_MAPPING[activeresource_klass.name].try(:constantize)
        end

        # True if the activeresource class has already been adapted to respond to the corresponding activerecord class
        def activeresource_to_activerecord_class_mapped?(activeresource_klass)
          activeresource_klass.mapped_to_activerecord if activeresource_klass.respond_to?(:mapped_to_activerecord)
        end

        # Inject methods in actiresource_klass to respond to expected ActiveRecord equivalent's model methods
        def force_activeresource_class_to_respond_to_activerecord_methods(activeresource_klass, activerecord_klass)
          # The mapping give us the body of the new created methods for some attributes, as well as the list of attributes
          # to exclude (those we don't want a method to respond to)
          activeresource_base_klass = activeresource_klass.parents[-2] # the last before Object
          mapping = activerecord_klass::ACTIVE_RESOURCE_MAPPING_CLASSES[activeresource_base_klass.name.to_sym]

          # First we process special attributes defined in the mapping
          special_attrs = mapping[:attributes][:special] || Hash.new
          special_attrs.each do |name, body|
            if name.to_s =~ /\?/
              activeresource_klass.class_eval("define_method(:#{name}) { #{body} }")
            else
              activeresource_klass.class_eval("attr_accessor_with_default(:#{name}) { #{body} }")
            end
          end

          # Then we process the rest of attributes of the activerecord class to ensure that all instances of
          # the activeresource class respond to this methods even in the attribute doesn't come in the activeresource instance
          exclude_attrs_names = mapping[:attributes][:exclude].map(&:to_s) rescue []
          normal_attrs_names = activerecord_klass.column_names - special_attrs.keys.map(&:to_s) - exclude_attrs_names
          normal_attrs_names.each do |name|
            activeresource_klass.class_eval("attr_accessor_with_default(:#{name}) { attributes[:#{name}] }")
          end

          # Finally, we mark the activeresource class as mapped for future checks.
          activeresource_klass.class_eval do
            mattr_accessor :mapped_to_activerecord
            @@mapped_to_activerecord = false
          end if not activeresource_klass.respond_to?(:mapped_to_activerecord)
          activeresource_klass.mapped_to_activerecord = true
        end

    end
  end
end
