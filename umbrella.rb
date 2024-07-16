require "http"
require "json"

pp "Will you need an umbrella today?"
pp "Where are you?"
user_location = gets.chomp

pp "Checking the weather in #{user_location}, Please hold..."

#LOCATION

gmaps_key =  ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

raw_gmaps_data = HTTP.get(gmaps_url)

parsed_gmaps_data = JSON.parse(raw_gmaps_data)

results_array = parsed_gmaps_data.fetch("results")

first_result_hash = results_array.at(0)

geometry_hash = first_result_hash.fetch("geometry")

location_hash = geometry_hash.fetch("location")

latitude = location_hash.fetch("lat")

longitude = location_hash.fetch("lng")

pp "Your coordinates are #{latitude}, #{longitude}."

#WEATHER

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"

raw_pirate_weather_data = HTTP.get(pirate_weather_url)

parsed_pirate_weather_data = JSON.parse(raw_pirate_weather_data)

currently_hash = parsed_pirate_weather_data.fetch("currently")

current_temp = currently_hash.fetch("temperature")

puts "It is currently #{current_temp}°F."

hourly_data = parsed_pirate_weather_data.fetch("hourly").fetch("data")
umbrella_needed = false

hourly_data.first(12).each_with_index do |hour_data, index|
  precip_prob = hour_data.fetch("precipProbability") * 100
  if precip_prob > 10
    pp "In #{index + 1} hours, the precipitation probability is #{precip_prob}%."
    umbrella_needed = true
  end
end

if umbrella_needed
  pp "You might want to carry an umbrella!"
else
  pp "You probably won't need an umbrella today."
end
