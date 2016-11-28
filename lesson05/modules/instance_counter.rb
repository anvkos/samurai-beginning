module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    protected

    attr_writer :instances
  end

  module InstanceMethods
    protected

    def register_instance
      instances = self.class.instances || 0
      self.class.send :instances=, instances + 1
    end
  end
end
