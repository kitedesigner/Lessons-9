require_relative "instance_counter.rb"
require_relative "manufacturer.rb"
require_relative "validation.rb"
require_relative "accessors.rb"
require_relative "common.rb"

class Train
  include Manufacturer
  include InstanceCounter
  extend Accessors
  include Validation
  include Common
  attr_reader :type, :speed, :route, :wagons, :number
  strong_attr_accessor :number, String

  FORMAT_NUMBER = /^[a-zа-я\d]{3}[-]?[a-zа-я\d]{2}$/i.freeze

  validate :name, :presence
  validate :name, :format, FORMAT_NUMBER

  @@trains = {}

  def initialize(number)
    @number = number
    @type = type
    @speed = 0
    @wagons = []
    validate!
    @@trains[number] = self
    register_instance
  end

  def self.all
    @@trains.values
  end

  def self.find(number)
    @@trains[number]
  end

  def each_wagon
    @wagons.each { |wagon| yield(wagon) }
  end

  def increase_speed(speed)
    @speed += speed if speed > 0
  end

  def decrease_speed(speed)
    if @speed - speed < 0
      @speed  = 0
    else
      @speed -= speed
    end
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if attachable_wagon?(wagon)
  end

  def remove_wagon(remove_wagon)
    @wagons.delete(remove_wagon)
  end

  def add_route(route)
    @route = route
    @current_station_index = 0
    route.first_station.accept_train(self)
  end

  def move_to_next_station
    return false unless next_station

    current_station.send_train(self)
    next_station.accept_train(self)
    @current_station_index += 1
  end

  def move_to_previous_station
    return false unless previous_station

    current_station.send_train(self)
    previous_station.accept_train(self)
    @current_station_index -= 1
  end

  protected

  def current_station
    route.stations[@current_station_index]
  end

  def previous_station
    route.stations[@current_station_index - 1] unless @current_station_index.zero?
  end

  def next_station
    route.stations[@current_station_index + 1]
  end
end
