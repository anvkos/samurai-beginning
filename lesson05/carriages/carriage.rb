require_relative '../modules/vendor.rb'
require_relative '../modules/validation.rb'

class Carriage
  include Vendor
  include Validation

  TYPES = [
    :cargo,
    :passenger
  ].freeze

  attr_reader :type

  validate :type, :presence

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
