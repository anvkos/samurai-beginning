class Carriage
  TYPES = [
    :cargo,
    :passenger
  ]

  attr_reader :type

  def initialize(type = :passenger)
    @type = type
  end
end
