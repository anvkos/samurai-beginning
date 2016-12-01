module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        @history_values ||= {}
        @history_values[var_name] ||= []
        @history_values[var_name] << value
      end
      define_method("#{name}_history") { @history_values[var_name] ? @history_values[var_name] : [] }
    end
  end

  # use as example: strong_attr_acessor one: Numeric, two: String
  def strong_attr_acessor(names = {})
    names.each do |name, klass|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        raise TypeError, "Attribute #{var_name}: type of value should be #{klass}" unless value.is_a?(klass)
        instance_variable_set(var_name, value)
      end
    end
  end
end
