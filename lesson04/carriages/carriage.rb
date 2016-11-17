class Carriage
  TYPES = [
    :cargo,
    :passenger
  ]

  attr_reader :type, :train

  def initialize(type = :passenger)
    @type = type
  end

  def train=(train)
    @train = train if attach_allowed?(train)
  end

  def detach
    self.train = nil unless self.train.nil?
  end

  protected

  def attach_allowed?(train)
    self.train.nil? && self.type == train.type
  end
end
