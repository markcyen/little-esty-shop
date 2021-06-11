class Holiday
  attr_reader :name,
              :date

  def initialize(holiday)
    @name = holiday[:localName]
    @date = holiday[:date]
  end
end
