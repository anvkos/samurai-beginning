require_relative '../modules/vendor'
require_relative '../modules/instance_counter'

class Train
  include Vendor
  include InstanceCounter

  TYPES = [
    :cargo,
    :passenger
  ]

  @@trains = []

  attr_reader :number, :type, :carriages, :speed, :carriages
  attr_writer :route

  def initialize(number = 0, type = :passenger)
    @number = number
    @type = type
    @carriages = []
    @speed = 0.0
    @current_station = 0
    @@trains.push(self)
    register_instance
  end

  def up_speed(speed)
    @speed += speed.to_f
  end

  def stop
    @speed = 0
  end

  def attach(carriage)
    @carriages << carriage if attach_allowed?(carriage)
  end

  def detach(carriage)
    @carriages.delete(carriage) if self.speed.zero?
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
    "number: #{self.number}, type: #{self.type}, carriages: #{self.carriages.count}"
  end

  def self.find(number)
    @@trains.select { |train| train.number == number }.first
  end

  protected

  def attach_allowed?(carriage)
    self.speed.zero? && self.type == carriage.type
  end

  def next_station_exist?
    return false if @route.nil?
    @current_station + 1 < @route.stations.count
  end

  def prev_station_exist?
    return false if @route.nil? || @current_station.zero?
    true
  end
end
