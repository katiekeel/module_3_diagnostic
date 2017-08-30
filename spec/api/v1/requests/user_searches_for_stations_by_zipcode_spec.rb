describe "User searches for alt fuel stations by zipcode and" do
  scenario "receives a list of 10 stations sorted by distance" do
    visit "/"
    VCR.use_cassette("api/v1/requests/user_searches_for_stations_by_zipcode_spec.rb") do
      fill_in "q", with: "80203"
      click_button "Locate"

      stations = AltFuelService.find_by_zipcode("80203")
      station = stations.first

      expect(station[:name]).to eq("UDR")
      expect(station[:address]).to eq("800 Acoma St Denver")
      expect(station[:fuel_type]).to eq("ELEC")
      expect(station[:distance]).to eq(0.31422)
      expect(station[:access_times]).to eq("24 hours daily")
    end
  end
end
