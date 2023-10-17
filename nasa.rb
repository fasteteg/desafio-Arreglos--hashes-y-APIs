require 'net/http'
require 'uri'
require 'json'

#Método request:
def request(url)
  uri = URI("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=jAP8Y0I7Yk45HC9qSDKcUtl08MdK1b1ndkxbndAw")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.scheme == 'https'
  response = http.get(uri.path)
  raise StandardError, "Request failed with code #{response.code}" unless response.is_a?(Net::HTTPSuccess)
  JSON.parse(response.body)
rescue StandardError => e
  puts "An error occurred while making the request: #{e.message}"
  nil
end

# Método build_web_page:
def build_web_page(data)
    page = <<~HTML
      <html>
        <head>
          <title>Photos</title>
        </head>
        <body>
          <ul>
            <% data['items'].each do |item| %>
              <li><img src="<%= item['link'] %>"></li>
            <% end %>
          </ul>
        </body>
      </html>
    HTML
    File.open('photos.html', 'w') { |file| file.puts page }
  end

  # Método photos_count:
  def photos_count(data)
    cameras = {}
    data['items'].each do |item|
      camera = item['camera']['name']
      cameras[camera] ||= 0
      cameras[camera] += 1
    end
    cameras
  end

  # En este método, definimos una variable llamada cameras que será nuestro hash final que asocia el nombre de la cámara con la cantidad de fotos. 
  # Luego, iteramos sobre la matriz data['items'] y extraemos el nombre de la cámara de cada elemento. Utilizamos el operador ||= para inicializar el valor de la cámara en el hash a 0 si no existe ya. 
  # Por último, incrementamos el valor de la cámara en uno para cada foto encontrada. Al final, devolvemos el hash completo.