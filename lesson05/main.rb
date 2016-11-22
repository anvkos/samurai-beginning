require_relative 'route'
require_relative 'station'
require_relative 'carriages/cargo_carriage'
require_relative 'carriages/passenger_carriage'
require_relative 'trains/cargo_train'
require_relative 'trains/passenger_train'

class RailWayControl
  def initialize()
    @stations = []
    @trains = []
    @routes = []
    @carriages = []
  end

  def execute
    loop do
      puts <<-MENU

      ######### MENU ##########
      Stations:
        [1] - List of stations
        [2] - Create station
        [3] - List of trains at the station
      Trains:
        [4] - List of trains
        [5] - Create train
        [6] - Add carriage to train
        [7] - Detach carriage to train
        [8] - Place on a train station
      Routes:
        [9] - List of routes
        [10] - Create route
      #########################
      MENU
      puts 'Enter number action:'
      menu_item = gets.chomp.to_i
      case menu_item
      when 1
        print_stations
      when 2
        create_station
      when 3
        print_trains_at_station
      when 4
        print_trains
      when 5
        create_train
      when 6
        attach_carriage
      when 7
        detach_carriage
      when 8
        placed_station
      when 9
        print_routes
      when 10
        create_route
      end
    end
  end

private

def placed_station
    puts '[ Place in the station ]'
    print_stations
    puts 'Enter number station:'
    station = gets.chomp
    return if station.empty? || station.to_i.zero?
    index_station = station.to_i - 1
    @stations.fetch(index_station) do |i|
      puts "Station by number #{i + 1} not found "
      return
    end
    train = find_train
    return if train.nil?
    @stations[index_station].accept(train)
  end

  def print_trains_at_station
    puts '[ Trains at the station ]'
    print_stations
    puts 'Enter number station:'
    station = gets.chomp
    return if station.empty? || station.to_i.zero?
    index_station = station.to_i - 1
    @stations.fetch(index_station) do |i|
      puts "Station by number #{i + 1} not found "
      return
    end
    puts @stations[index_station].trains
  end

  def create_train
    puts '[ Creating train. ]'
    number = number_train
    return if number.nil?

    types = Train::TYPES.map.with_index { |type, i| "[#{i + 1}] - #{type.to_s}" }.join(', ')
    puts "Enter type train. #{types}:"
    type = gets.chomp.to_i
    type = Train::TYPES[type - 1]
    return if type.nil?

    train = CargoTrain.new(number) if type == :cargo
    train = PassengerTrain.new(number) if type == :passenger
    @trains.push(train)

    puts "How many carriages attach?:"
    amount = gets.chomp
    return if amount.empty? || amount.to_i.zero?
    attach_many_carriages(train, amount.to_i)
  end

  def number_train
    puts "Enter number train:"
    number = gets.chomp
    return nil if number.empty? || number.to_i.zero?
    number.to_i
  end

  def find_train
    number = number_train
    @trains.select {|train| train.number == number }.first
  end

  def attach_carriage
    train = find_train
    return if train.nil?
    attach_many_carriages(train, 1)
  end

  def detach_carriage
    train = find_train
    return if train.nil?
    index_train = @trains.index(train)
    carriage = @trains[index_train].carriages.last
    @trains[index_train].detach(carriage)
  end

  def attach_many_carriages(train, amount)
    index = @trains.index(train)
    if train.type == :passenger
      amount.times { @trains[index].attach(PassengerCarriage.new) }
    elsif train.type == :cargo
      amount.times { @trains[index].attach(CargoCarriage.new) }
    end
  end

  def print_trains
    puts '[ List of trains. ]'
    if @trains.empty?
      puts 'List trains empty.'
      return
    end
    @trains.each { |train| puts "#{train.number} - Train #{train}" }
  end

  def print_stations
    if @stations.empty?
      puts 'List stations empty.'
      return
    end
    puts "[ List stations. ]"
    @stations.each_with_index { |station, i| puts "#{i + 1} - #{station.name}" }
  end

  def create_station
    puts '[ Creating station. ]'
    puts 'Enter name station:'
    name = gets.chomp
    return if name.empty?
    @stations.push(Station.new(name))
  end

  def print_routes
    if @routes.empty?
      puts 'List routes empty.'
      return
    end
    puts '[ List routes. ]'
    @routes.each_with_index { |route, i|  puts "#{i + 1} - #{info_route(route)}" }
  end

  def info_route(route)
    stations = route.stations.map { |station| station.name }.join(', ')
    "#{route.stations.first.name} to #{route.stations.last.name}: #{stations}"
  end

  def create_route
    puts '[ Creating route. ]'
    puts "Enter name starting station:"
    staring_name = gets.chomp
    starting_station = find_or_create_station(staring_name)
    puts "Enter name ending station:"
    ending_name = gets.chomp
    ending_station = find_or_create_station(ending_name)
    route = Route.new(starting_station, ending_station)
    @routes.push(route)
    puts 'Enter the name of the intermediate stations, separated by commas:'
    name_stations = gets.chomp
    return if name_stations.empty?
    index = @routes.index(route)
    stations = create_many_stations(name_stations)
    add_many_stations(@routes[index], stations)
  end

  def create_many_stations(names)
    names = names.split(',').map { |n| n.strip! }
    stations = @stations.select { |station| names.include?(station.name) }
    new_names = names - stations.map { |station| station.name }
    new_names.each do |name|
      station = Station.new(name)
      @stations.push(station)
      stations.push(station)
    end
    stations
  end

  def add_many_stations(route, stations)
    stations.each { |station| route.add_station(station) }
  end

  def find_station_by_name(name)
    @stations.select { |s| s.name == name }.first
  end

  def find_or_create_station(name)
    station = find_station_by_name(name)
    if station.nil?
      station = Station.new(name)
      @stations.push(station)
    end
    station
  end
end

railway = RailWayControl.new
railway.execute
