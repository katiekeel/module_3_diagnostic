class AltFuelService

  attr_reader :zipcode

  def initialize(zipcode)
    @zipcode = zipcode
    @conn = Faraday.new(url: "https://api.data.gov/nrel/alt-fuel-stations/v1") do |faraday|
      faraday.headers["X-API-KEY"] = ENV["ALTFUEL_KEY"]
      faraday.adapter Faraday.default_adapter
    end
  end

  def get_url(url)
    response = @conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.find_by_zipcode(zipcode)
    new(zipcode).find_by_zipcode
  end

  def find_by_zipcode
    get_url("/nearest.json?location=#{zipcode}")
  end

end
