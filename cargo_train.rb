class CargoTrain < Train
  attr_reader :type

  FORMAT_NUMBER = /^[a-zа-я\d]{3}[-]?[a-zа-я\d]{2}$/i.freeze

  validate :number, :presence
  validate :number, :format, FORMAT_NUMBER
  validate :number, :type, String
  def initialize(number)
    super(number)
    @type = :cargo
  end

  def attachable_wagon?(wagon)
    wagon.is_a?(CargoWagon)
  end
end
