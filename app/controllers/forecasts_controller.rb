class ForecastsController < ApplicationController
  def index
    city = params[:city] || "chicago"
    state = params[:state] || "il"


    initial_response = Unirest.get("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22#{city}%2C%20#{state}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys").body
    @weather = initial_response["query"]["results"]["channel"]
    @temp = @weather["item"]["condition"]["temp"]
    @temp_unit = @weather["units"]["temperature"]

    @forecasts = @weather["item"]["forecast"].first(5)
    @city = @weather["location"]["city"]
    @state = @weather["location"]["region"]

    image_description = @weather["item"]["description"]
    @image = /(?<=src=")(.*).gif(?=")/.match(image_description)
  end
end
