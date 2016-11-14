=begin
Класс Train (Поезд):
Имеет номер (произвольная строка) и тип (грузовой, пассажирский)
 и количество вагонов, эти данные указываются при создании экземпляра класса
Может набирать скорость
Может показывать текущую скорость
Может тормозить (сбрасывать скорость до нуля)
Может показывать количество вагонов
Может прицеплять/отцеплять вагоны (по одному вагону за операцию,
 метод просто увеличивает или уменьшает количество вагонов).
Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
Может принимать маршрут следования (объект класса Route)
Может перемещаться между станциями, указанными в маршруте.
Показывать предыдущую станцию, текущую, следующую, на основе маршрута
=end

class Train
  TYPES = {
    cargo: 'cargo',
    passenger: 'passenger'
  }

  attr_reader :number, :type, :carriages, :speed, :carriages
  attr_writer :route

  def initialize(number = 0, type = 'passenger', carriages = 0)
    @number = number.to_i
    @type = type.to_s
    @carriages = carriages.to_i
    @speed = 0
    @current_station = 0
  end

  def up_speed(speed)
    @speed += speed.to_f
  end

  def stop
    @speed = 0
  end

  def inc_carriage
    @carriages += 1 if self.speed.zero?
  end

  def dec_carriage
    if self.speed.zero? && self.carriages > 0
      @carriages -= 1
    end
  end

  def current_station
    @route.stations[@current_station] unless @route.nil?
  end

  def prev_station
    @route.stations[@current_station - 1] if prev_station_exist?
  end

  def next_station
    @route.stations[@current_station + 1] if next_station_exist?
  end

  def move_next_station
    @current_station += 1 if next_station_exist?
  end

  def move_prev_station
    @current_station -= 1 if prev_station_exist?
  end

  def to_s
    "number: #{self.number} type: #{self.type} carriages: #{self.carriages}"
  end

  private

  def next_station_exist?
    return false if @route.nil?
    @current_station + 1 < @route.stations.count
  end

  def prev_station_exist?
    return false if @route.nil? || @current_station.zero?
    true
  end
end
