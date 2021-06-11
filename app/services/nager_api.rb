class NagerAPI
  def self.retrieve_holidays
    response = Faraday.get "https://date.nager.at/Api/v2/NextPublicHolidays/US"
    body = response.body
    JSON.parse(body, symbolize_names: true)
  end

  def self.upcoming_holidays
    retrieve_holidays[0..2].map do |holiday|
      Holiday.new(holiday)
    end
  end
end
