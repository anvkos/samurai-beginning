require_relative 'carriage'

class PassengerCarriage < Carriage

  attr_reader :seats, :occupied_seats

  def initialize(seats = 54)
    super(:passenger)
    @seats = seats
    @occupied_seats = 0
  end

  def free_seats
    self.seats - self.occupied_seats
  end

  def occupy_seat
    raise RuntimeError, 'No free seats in the carriage' if free_seats.zero?
    @occupied_seats += 1
  end
end
