require_relative 'modules/validation.rb'

class Station
  include Validation

  @@stations = []

  attr_reader :name

  validate :name, :presence
  validate :name, :min_length, 3

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

  def trains(&_block)
    if block_given?
      @trains.each { |train| yield(train) }
    else
      @trains
    end
  end

  def accept(train)
    trains << train
  end

  def send_to(train)
    trains.delete(train)
  end

  def count_trains(type)
    trains.select do |train|
      train.type == type
    end.size
  end

  def to_s
    name
  end
end
