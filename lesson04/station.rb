=begin
Класс Station (Станция):
Имеет название, которое указывается при ее создании
Может принимать поезда (по одному за раз)
Может показывать список всех поездов на станции, находящиеся в текущий момент
Может показывать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
Может отправлять поезда (по одному за раз,
при этом, поезд удаляется из списка поездов, находящихся на станции).
=end

class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def accept(train)
    trains.push(train)
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
end
