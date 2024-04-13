require 'rack'
include HTTParty
require_relative 'models/earthquake' # invocacion al modelo

class FrogmiEarthquakeApp
  def call(env) # mandatory method call name
    # Aquí es donde manejarás las peticiones entrantes y devolverás las respuestas
    # Por ahora, simplemente devolveremos un mensaje de respuesta básico
    puts "ddadasdsa"
    
    base_uri 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary'
    response = get('/all_month.geojson')
      
    if response.success?
      data = JSON.parse(response.body)
      create(data)
    else
      puts 'Failed to fetch data from USGS'
    end
    [200, { 'Content-Type' => 'text/html' }, ['¡Hola desde mi aplicación Rack!']]
  end
end