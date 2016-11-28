require_relative 'train'

class PassengerTrain < Train
  def initialize(number, options = {})
    super(number, :passenger, options)
  end
end
