require_relative "instance_counter.rb"
require_relative "validation.rb"
require_relative "accessors.rb"
require_relative "common.rb"

class Station
  include InstanceCounter
  include Validation
  extend Accessors
  include Common
  attr_reader :trains, :name

  FORMAT_NUMBER = /^[a-zа-я\d]{3}[-]?[a-zа-я\d]{2}$/i.freeze

  validate :name, :presence
  validate :name, :format, FORMAT_NUMBER

  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def self.all
    @@stations
  end

  def each_train
    @trains.each { |train| yield(train) }
  end

  def accept_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def select_trains(type)
    trains.select { |train| train.type == type }
  end
end
