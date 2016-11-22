class Station
  @@stations = []

  attr_reader :name, :trains

  def initialize(name)
    @name = name
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

  def self.all
    @@stations
  end
end
