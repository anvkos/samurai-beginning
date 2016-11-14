require_relative 'station'
require_relative 'route'
require_relative 'train'

nsk = Station.new('Novosibirsk')
omsk = Station.new('Omsk')
msk = Station.new('Mosсow')

t_789 = Train.new(789, Train::TYPES[:passenger], 20)
t_789.inc_carriage
t_789.up_speed(80.5)
t_789.inc_carriage
puts "Train #{t_789}"
t_789.stop
t_789.dec_carriage
t_789.dec_carriage
puts "Train #{t_789}"

puts '#'*10
nsk_to_msk = Route.new(nsk, msk)
nsk_to_msk.add_station(omsk)
puts "Route: "
puts nsk_to_msk.stations
puts '#'*10
t_889 = Train.new(889, Train::TYPES[:cargo], 50)

t_889.route = nsk_to_msk
puts "Train #{t_889}"
puts "Current station: #{t_889.current_station}"
puts "Next station: #{t_889.next_station}"

puts "Train number #{t_889.number} move to #{t_889.next_station}"
t_889.move_next_station
omsk.accept(t_889)
puts "The train number #{t_889.number} arrived at the station #{omsk.name}"
counter_trains = omsk.count_trains
puts "The station is now:"
puts "Passenger trains: #{counter_trains[:passenger]}"
puts "Cargo trains: #{counter_trains[:cargo]}"
puts '#'*10
puts "Train #{t_889}."
puts "Prev station: #{t_889.prev_station}"
puts "Current station: #{t_889.current_station}"
puts "Next station: #{t_889.next_station}"
