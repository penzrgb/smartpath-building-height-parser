require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'csv'

@doc = Nokogiri::XML.parse(open("Geelong.kml"))
@doc.remove_namespaces!

items = @doc.xpath('//Placemark')
id = 0

CSV.open("results.csv", "w") do |csv|
  items.each do |placemark|
    extended = placemark.css('ExtendedData')
    extended.each do |eData|
      simple = eData.css('SimpleData').css('SimpleData')
      if simple.count != 0 
        simple.each do |simpledata|
          if simpledata.attr('name') == 'ROOF_HT'
            # Great! This datapoint has a roof height associated with it.
            roof_height = simpledata.children[0].to_s

            # What is it's coordinates?
            longitude = placemark.css('longitude').children[0].to_s
            latitude = placemark.css('latitude').children[0].to_s
            csv << [id, longitude, latitude, roof_height] 
            id += 1
          end
        end
      end
    end
  end
end
