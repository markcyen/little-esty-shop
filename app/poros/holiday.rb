class Holiday
  def upcoming_holidays
    NagerAPI.retrieve_holidays[0..2].map do |holiday|
      holiday
    end
  end
end
