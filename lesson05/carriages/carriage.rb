require_relative '../modules/vendor.rb'
require_relative '../modules/validatable.rb'

class Carriage
  include Vendor
  include Validatable

  TYPES = [
    :cargo,
    :passenger
  ].freeze

  attr_reader :type

  def initialize(type = :passenger, options = {})
    @type = type
    validate!
    @vendor = options[:vendor]
  end

  protected

  def validate!
    raise ArgumentError, "Type must be one of the :#{TYPES.join(', :')}" unless TYPES.include?(@type)
    true
  end
end
