require_relative 'modules/validation'
require_relative 'modules/accessors'

class TestValidation
  include Validation
  extend Accessors

  attr_accessor_with_history :city

  validate :city, :type, String
  validate :city, :min_length, 3
  validate :city, :format, /^[A-Z][a-z]+$/

  def validation!
    validate!
  end
end

city_names = [
  123,
  'ns',
  'nsk',
  'Ns1',
  'Nsk'
]

test = TestValidation.new

attempt = 0
begin
  city_name = city_names[attempt]
  test.city = city_name
  test.validation!
  puts 'Validation check is completed!'
  puts 'Sets the value of city:'
  p test.city_history
rescue => e
  puts "[Check] city=#{city_name} #{e.message}"
  attempt += 1
  retry if attempt < city_names.size
end
