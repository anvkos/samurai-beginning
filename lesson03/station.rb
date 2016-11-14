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
    trains.delete_if { |t| train == t }
  end

  def count_trains
    counter = {
      passenger: 0,
      cargo: 0
    }
    self.trains.each do |train|
      counter[:passenger] += 1 if train.type == Train::TYPES[:passenger]
      counter[:cargo] += 1     if train.type == Train::TYPES[:cargo]
    end
    counter
  end

  def to_s
    name
  end
end
