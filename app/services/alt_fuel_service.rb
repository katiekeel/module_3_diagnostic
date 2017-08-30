class AltFuelService

  attr_reader :zipcode

  def initialize(zipcode)
    @zipcode = zipcode
    @conn = Faraday.new(url: "https://developer.nrel.gov/api/alt-fuel-stations/v1/") do |faraday|
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
    results = get_url("nearest.json?location=#{zipcode}&radius=6&fuel_type=ELEC,LPG&limit=10&api_key=#{ENV["ALTFUEL_KEY"]}&format=JSON")
    sort_results(results)
  end

  def sort_results(results)
    new_results = []
    results.to_a.reverse.to_h.first[1].each do |result|
      new_results << {name: result[:station_name],
                      address: result[:street_address] + " " + result[:city],
                      fuel_type: result[:fuel_type_code],
                      distance: result[:distance],
                      access_times: result[:access_days_time]}
    end
    new_results
  end

end
