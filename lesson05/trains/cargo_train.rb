require_relative 'train'

class CargoTrain < Train
  def initialize(number, options = {})
    super(number, :cargo, options)
  end
end
