require_relative 'station'
require_relative 'modules/validatable'

class Route
  include Validatable

  attr_reader :stations

  def initialize(starting, ending)
    @stations = [starting, ending]
    validate!
  end

  def add_station(station)
    stations.insert(-2, station) if intermediary?(station)
  end

  def delete_station(station)
    stations.delete_if { |s| station == s } if intermediary?(station)
  end

  private

  def intermediary?(station)
    station != stations.first && station != stations.last
  end

  def validate!
    stations.each do |station|
      raise ArgumentError, 'Stations must be instances of Station class' unless station.is_a?(Station)
    end
    true
  end
end
