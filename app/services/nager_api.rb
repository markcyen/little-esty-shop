class NagerAPI
  def self.retrieve_holidays
    response = Faraday.get "https://date.nager.at/Api/v2/NextPublicHolidays/US"
    JSON.parse(response.body, symbolize_names: true)
  end
end
