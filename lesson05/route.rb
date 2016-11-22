require_relative 'station'

class Route
  attr_reader :stations

  def initialize(starting, ending)
    @stations = [starting, ending]
  end

  def add_station(station)
    self.stations.insert(-2, station) if intermediary?(station)
  end

  def delete_station(station)
    if intermediary?(station)
      self.stations.delete_if { |s| station == s }
    end
  end

  private

  def intermediary?(station)
    station != self.stations.first && station != self.stations.last
  end
end
