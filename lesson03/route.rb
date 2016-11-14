=begin
Класс Route (Маршрут):
- Имеет начальную и конечную станцию, а также список промежуточных станций.
 Начальная и конечная станции указываютсся при создании маршрута,
 а промежуточные могут добавляться между ними.
- Может добавлять промежуточную станцию в список
- Может удалять промежуточную станцию из списка
- Может выводить список всех станций по-порядку от начальной до конечной
=end
require_relative 'station'

class Route
  attr_reader :stations

  def initialize(starting, ending)
    @stations = [starting, ending]
  end

  def add_station(station)
    self.stations.insert(-2, station)
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
