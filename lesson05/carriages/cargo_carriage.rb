require_relative 'carriage'

class CargoCarriage < Carriage
  attr_reader :volume, :filled_volume

  def initialize(volume = 120, options = {})
    super(:cargo, options)
    @volume = volume
    @filled_volume = 0
  end

  def fill_volume(volume)
    raise 'Exceeding the available volume' if available_volume < volume
    @filled_volume += volume
  end

  def available_volume
    volume - filled_volume
  end
end
