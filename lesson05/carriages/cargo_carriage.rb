require_relative 'carriage'

class CargoCarriage < Carriage
  attr_reader :volume, :filled_volume

  def initialize(volume = 120)
    super(:cargo)
    @volume = volume
    @filled_volume = 0
  end

  def fill_volume(volume)
    raise RuntimeError, 'Exceeding the available volume' if available_volume < volume
    @filled_volume += volume
  end

  def available_volume
    self.volume - self.filled_volume
  end
end
