class Station
  @@stations = []

  attr_reader :name, :trains

  class << self
    def all
      @@stations
    end
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@stations << self
  end

  def accept(train)
    trains << train
  end

  def send(train)
    trains.delete(train)
  end

  def count_trains(type)
    self.trains.select do |train|
      train.type == type
    end.count
  end

  def to_s
    name
  end

  private

  def validate!
    raise ArgumentError, 'Name can not be empty' if @name.nil? || @name.to_s.empty?
    raise ArgumentError, 'Name should be at least 3 symbols' if @name.to_s.length < 3
    true
  end
end
