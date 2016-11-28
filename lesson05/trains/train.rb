require_relative '../modules/vendor'
require_relative '../modules/validatable'
require_relative '../modules/instance_counter'

class Train
  include Vendor
  include Validatable
  include InstanceCounter

  TYPES = [
    :cargo,
    :passenger
  ].freeze

  NUMBER_FORMAT = /^([a-z]|\d){3}-?([a-z]{2}|\d{2})$/i

  @@trains = {}

  attr_reader :number, :type, :speed
  attr_writer :route

  class << self
    def find(number)
      @@trains[number]
    end
  end

  def initialize(number = 0, type = :passenger, options = {})
    @number = number
    @type = type
    validate!
    @carriages = []
    @speed = 0.0
    @current_station = options[:current_station] ||= 0
    @vendor = options[:vendor]
    @@trains.store(number, self)
    register_instance
  end

  def up_speed(speed)
    @speed += speed.to_f
  end

  def stop
    @speed = 0
  end

  def carriages(&_block)
    if block_given?
      @carriages.each { |carriage| yield(carriage) }
    else
      @carriages
    end
  end

  def attach(carriage)
    @carriages << carriage if attach_allowed?(carriage)
  end

  def detach(carriage)
    @carriages.delete(carriage) if speed.zero?
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
    "number: #{number}, type: #{type}, carriages: #{carriages.count}"
  end

  protected

  def validate!
    raise ArgumentError, 'Number must be of the form xxx-xx' if NUMBER_FORMAT !~ @number.to_s
    raise ArgumentError, "Type must be one of the :#{TYPES.join(', :')}" unless TYPES.include?(@type)
    true
  end

  def attach_allowed?(carriage)
    speed.zero? && type == carriage.type
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
