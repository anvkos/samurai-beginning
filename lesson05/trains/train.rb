require_relative '../modules/vendor'
require_relative '../modules/validation'
require_relative '../modules/accessors'
require_relative '../modules/instance_counter'
require_relative '../route'

class Train
  include Vendor
  extend Accessors
  include Validation
  include InstanceCounter

  TYPES = [
    :cargo,
    :passenger
  ].freeze

  NUMBER_FORMAT = /^([a-z]|\d){3}-?([a-z]{2}|\d{2})$/i

  @@trains = {}

  attr_reader :number, :type, :speed
  strong_attr_acessor route: Route

  validate :number, :format, NUMBER_FORMAT

  class << self
    def find(number)
      @@trains[number]
    end
  end

  def initialize(number, type = :passenger, options = {})
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
    super
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
