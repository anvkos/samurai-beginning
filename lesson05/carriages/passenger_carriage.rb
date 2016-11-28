require_relative 'carriage'

class PassengerCarriage < Carriage
  attr_reader :seats, :occupied_seats

  def initialize(seats = 54, options = {})
    super(:passenger, options)
    @seats = seats
    @occupied_seats = 0
  end

  def free_seats
    seats - occupied_seats
  end

  def occupy_seat
    raise 'No free seats in the carriage' if free_seats.zero?
    @occupied_seats += 1
  end
end
