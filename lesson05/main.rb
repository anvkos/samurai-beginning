require_relative 'route'
require_relative 'station'
require_relative 'carriages/cargo_carriage'
require_relative 'carriages/passenger_carriage'
require_relative 'trains/cargo_train'
require_relative 'trains/passenger_train'

class RailWayControl
  def initialize
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
        [9] - List of carriage in train
        [10] - Occupied seat or fill volume in carriage
      Routes:
        [15] - List of routes
        [16] - Create route
      #########################
      MENU
      puts 'Enter number action:'
      menu_item = gets.chomp.to_i
      case menu_item
      when 1
        puts '[ List stations. ]'
        print_stations
      when 2
        puts '[ Creating station. ]'
        create_station
        puts "Created station: #{@stations.last}"
      when 3
        puts '[ Trains at the station ]'
        print_trains_at_station
      when 4
        puts '[ List of trains. ]'
        print_trains
      when 5
        puts '[ Creating train. ]'
        create_train
        puts "Created train: #{@trains.last}"
      when 6
        attach_carriage
      when 7
        detach_carriage
      when 8
        puts '[ Place in the station ]'
        placed_station
      when 9
        puts '[ List carriage in the train ]'
        print_carriages_train
      when 10
        puts '[ Occupied seat or fill volume in carriage the train]'
        print_trains
        fill_carriage_train
      when 15
        puts '[ List routes. ]'
        print_routes
      when 16
        puts '[ Creating route. ]'
        create_route
        puts "Created route: #{info_route(@routes.last)}"
      end
    end
  end

  private

  def fill_carriage_train
    train = find_train
    return if train.nil?
    list_carriages_train(train)
    number = number_carriage(train)
    return if number.nil?
    carriage = train.carriages[number.to_i - 1]
    carriage =
      if train.type == :cargo
        fill_volume_carriage(carriage)
      elsif train.type == :passenger
        occupied_seat_carriage(carriage)
      end
    index = @trains.index(train)
    @trains[index].carriages[number.to_i - 1] = carriage
  end

  def number_carriage(train)
    puts 'Enter number carriage:'
    number = gets.chomp
    return if number.nil?
    raise 'Wrong number carriage!' if train.carriages[number.to_i - 1].nil?
    number
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def occupied_seat_carriage(carriage)
    carriage.occupy_seat
    puts 'Occupied seat.'
    carriage
  rescue RuntimeError => e
    pust "[ERROR] #{e.message}"
  end

  def fill_volume_carriage(carriage)
    puts 'Enter volume:'
    volume = gets.chomp
    return carriage if volume.nil?
    carriage.fill_volume(volume.to_f)
    puts "Filled #{volume}."
    carriage
  rescue RuntimeError => e
    puts "[ERROR] #{e.message}"
    retry
  end

  def print_carriages_train
    train = find_train
    return if train.nil?
    list_carriages_train(train)
  end

  def list_carriages_train(train)
    i = 0
    train.carriages do |car|
      i += 1
      if car.type == :passenger
        puts "#{i} #{car.type}, seats - free #{car.free_seats}, occupied: #{car.occupied_seats}"
      elsif car.type == :cargo
        puts "#{i} #{car.type}, volume - available: #{car.available_volume}, filled: #{car.filled_volume}"
      end
    end
  end

  def placed_station
    print_stations
    puts 'Enter number station:'
    number_station = gets.chomp
    return if number_station.empty? || number_station.to_i.zero?
    index_station = number_station.to_i - 1
    unless station_exist?(index_station)
      puts "Station by number #{number_station} not found "
      return
    end
    train = find_train
    return if train.nil?
    @stations[index_station].accept(train)
  end

  def print_trains_at_station
    print_stations
    puts 'Enter number station:'
    number_station = gets.chomp
    return if number_station.empty? || number_station.to_i.zero?
    index_station = number_station.to_i - 1
    unless station_exist?(index_station)
      puts "Station by number #{number_station} not found "
      return
    end
    puts @stations[index_station].trains
  end

  def station_exist?(index)
    return true if @stations.fetch(index)
    false
  end

  def create_train
    number = number_train
    type = type_train
    train = Train.new(number, type)
    @trains << train
    puts 'How many carriages attach?:'
    amount = gets.chomp
    return if amount.empty? || amount.to_i.zero?
    attach_many_carriages(train, amount.to_i)
    train
  rescue ArgumentError => e
    puts "[ERROR] #{e.message}!"
    retry
  end

  def number_train
    puts 'Enter number train:'
    gets.chomp
  end

  def type_train
    types = Train::TYPES.map.with_index { |type, i| "[#{i + 1}] - #{type}" }.join(', ')
    puts "Enter type train. #{types}:"
    type = gets.chomp.to_i
    Train::TYPES[type - 1]
  end

  def find_train
    number = number_train
    @trains.detect { |train| train.number == number }
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
    @stations.each_with_index { |station, i| puts "#{i + 1} - #{station.name}" }
  end

  def create_station
    puts 'Enter name station:'
    name = gets.chomp
    station = Station.new(name)
    @stations << station
    station
  rescue ArgumentError => e
    puts "[ERROR] #{e.message}!"
    retry
  end

  def print_routes
    if @routes.empty?
      puts 'List routes empty.'
      return
    end
    @routes.each_with_index { |route, i| puts "#{i + 1} - #{info_route(route)}" }
  end

  def info_route(route)
    stations = route.stations.map(&:name).join(', ')
    "#{route.stations.first.name} to #{route.stations.last.name}: #{stations}"
  end

  def create_route
    puts 'Enter name starting station:'
    staring_name = gets.chomp
    starting_station = find_or_create_station(staring_name)
    puts 'Enter name ending station:'
    ending_name = gets.chomp
    ending_station = find_or_create_station(ending_name)
    route = Route.new(starting_station, ending_station)
    @routes << route
    add_intermediate_stations(route)
    route
  rescue ArgumentError => e
    puts "[ERROR] #{e.message}!"
    retry
  end

  def add_intermediate_stations(route)
    puts 'Enter the name of the intermediate stations, separated by commas:'
    name_stations = gets.chomp
    return if name_stations.empty?
    index = @routes.index(route)
    stations = create_many_stations(name_stations)
    add_many_stations(@routes[index], stations)
  rescue ArgumentError => e
    puts "[ERROR] #{e.message}!"
    retry
  end

  def create_many_stations(names)
    names = names.split(',').map(&:strip)
    stations = @stations.select { |station| names.include?(station.name) }
    new_names = names - stations.map(&:name)
    new_names.each do |name|
      station = Station.new(name)
      @stations << station
      stations << station
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
      @stations << station
    end
    station
  end
end

railway = RailWayControl.new
railway.execute
