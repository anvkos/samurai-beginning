require_relative 'station'
require_relative 'modules/validation'

class Route
  include Validation

  attr_reader :stations
  validate :stations, :type_elements, Station

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
end
