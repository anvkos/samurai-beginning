module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validation_attributes

    def validate(*args)
      validation = {
        type: args[1],
        options: args[2..-1]
      }
      self.validation_attributes ||= {}
      self.validation_attributes.store(args[0], validation)
    end

    protected

    attr_writer :validation_attributes
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    def validate!
      validation_attributes = self.class.validation_attributes
      validation_attributes.each do |attribute, validation|
        attr = "@#{attribute}"
        value = instance_variable_get(attr)
        send(validation[:type], attr, value, validation[:options])
      end
    end

    protected

    def presence(attr, value, _options = [])
      raise ArgumentError, "Attribute #{attr}: value empty" if value.nil? || value.to_s.empty?
      true
    end

    def format(attr, value, options)
      raise ArgumentError, "Attribute #{attr}: value is not of the format" if options.first !~ value.to_s
      true
    end

    def type(attr, value, options)
      klass = options.first
      raise TypeError, "Attribute #{attr}: type of value should be #{klass}" unless value.is_a?(klass)
      true
    end

    def type_elements(attr, values, options)
      values.each { |value| type(attr, value, options) }
    end

    def min_length(attr, value, options)
      min = options.first
      raise ArgumentError, "Attribute #{attr}: should be at least #{min_length} symbols" if value.to_s.length < min
    end
  end
end
