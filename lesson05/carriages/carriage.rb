require_relative '../modules/vendor.rb'
require_relative '../modules/validatable.rb'

class Carriage
  include Vendor
  include Validatable

  TYPES = [
    :cargo,
    :passenger
  ]

  attr_reader :type

  def initialize(type = :passenger)
    @type = type
    validate!
  end

  protected

  def validate!
    raise ArgumentError, "Type must be one of the :#{TYPES.join(', :')}" unless TYPES.include?(@type)
    true
  end
end
