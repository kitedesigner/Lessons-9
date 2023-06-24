require_relative "instance_counter.rb"
require_relative "validation.rb"

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations

  NO_EXIST_STATION_ERROR = 'Одна или более станций не существует'.freeze
  EQUALS_STATION_ERROR = 'Начальная и конечная станции совпадают'.freeze

  validate :first_station, :type, Station
  validate :last_station, :type, Station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station

    unless @stations.first.is_a?(Station) && @stations.last.is_a?(Station)
      raise NO_EXIST_STATION_ERROR
    end

    raise EQUALS_STATION_ERROR if @stations.first == @stations.last

    validate!
    @stations = [first_station, last_station]
    register_instance
  end

  def first_station
    stations.first
  end

  def last_station
    stations.last
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    return if [first_station, last_station].include?(station)

    stations.delete(station)
  end

  def show_stations
    stations.each { |station| puts station.name }
  end
end
