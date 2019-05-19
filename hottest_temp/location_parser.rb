class LocationParser
  attr_accessor :line, :location

  class << self
    attr_accessor :parsers

    def parser(line)
      parsers.map{ |p| p.new(line) }.find(&:matches?)
    end
  end

  def initialize(line)
    self.line     = line
    self.location = line
  end

  def query
    raise InvalidArgument, 'Abstract class #query called'
  end
end

require_relative 'location_parser/lat_lon_parser'
require_relative 'location_parser/city_parser'

LocationParser.parsers = [ZipParser, LatLonParser, CityParser]

