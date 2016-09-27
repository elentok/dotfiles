#!/usr/bin/ruby

require "#{ENV['DOTF']}/framework.rb"
require 'date'
require 'open-uri'
require_or_install_gem 'nokogumbo', 'nokogumbo'

HOMEPAGE_URL = 'http://www.rail.co.il/EN/Pages/homepage.aspx'

class CLI < OptionsCLI
  desc 'Train Schedule'
  usage 'train [options] <origin> <dest> [time]'
  cli_options(
    list: [ '-l', '--list',   'Lists all stations' ])

  def start
    if options[:list]
      puts Station.all
    elsif ARGV.length >= 2
      puts Train.find(origin_id, dest_id, time)
    else
      puts parser.help
      exit 1
    end
  end

  def time
    if ARGV[2]
      DateTime.parse(ARGV[2])
    else
      DateTime.now
    end
  end

  def origin_id
    find_station(ARGV[0]).id
  end

  def dest_id
    find_station(ARGV[1]).id
  end

  def find_station(name)
    station = stations.select { |s| s.name == name }.first
    if station.nil?
      puts "ERROR: Can't find station '#{name}'"
      exit 1
    else
      station
    end
  end

  def stations
    @stations ||= Station.all
  end
end

class Station
  attr_reader :id, :name, :title

  def initialize(raw = {})
    @id    = raw[:id]
    @name  = raw[:name]
    @title = raw[:title]
  end

  def self.all
    StationFetcher.new.fetch.map { |raw| Station.new(raw) }
  end

  def to_s
    "#{@name} (#{@title}, #{@id})"
  end
end

class StationFetcher
  def fetch
    FileCache.fetch('train-stations.yml') { load_stations }
  end

  def load_stations
    doc.css('#ctl00_PlaceHolderMain_ucSmallDrivePlan_cmbOriginStation option')
      .select { |option| option[:value] != '' }
      .map do |option|
        {
          id:    option[:value],
          title: option.text,
          name:  title_to_name(option.text)
        }
      end
  end

  def doc
    @doc ||= Nokogiri::HTML5(html)
  end

  def html
    FileCache.fetch('train-homepage.html') { open(HOMEPAGE_URL).read }
  end

  def title_to_name(title)
    title.downcase.gsub(/\(.*$/, '').gsub(/'/, '').strip.gsub(/ /, '-')
  end
end

class Train
  def initialize(raw = {})
    @departure = raw[:departure]
    @arrival   = raw[:arrival]
    @duration  = raw[:duration]
    @changing  = raw[:changing]
  end

  def self.find(origin_id, dest_id, datetime = DateTime.now)
    TrainFetcher.new(origin_id, dest_id, datetime).fetch
      .map { |t| Train.new(t) }
  end

  def to_s
    "#{@departure} => #{@arrival}\t (elapsed: #{@duration}) (#{@changing})"
  end
end

class TrainFetcher
  BASE_URL = "http://www.rail.co.il/EN/DrivePlan/Pages/DrivePlan.aspx"

  def initialize(origin_id, dest_id, datetime = DateTime.now)
    @origin_id = origin_id
    @dest_id = dest_id
    @datetime = datetime
  end

  def fetch
    doc.css('.timeTable tr[name=TrainRow]').map do |tr|
      tds = tr.css('> td')
      {
        departure: tds[1].text,
        arrival:   tds[2].text,
        duration:  tds[3].text,
        changing:  tds[4].text
      }
    end
  end

  def doc
    @doc ||= Nokogiri::HTML(html)
  end

  def html
    open(url).read
    # FileCache.fetch('train-schedule.html') { open(url).read }
  end

  def url
    BASE_URL + '?' + URI.encode_www_form(params)
  end

  def params
    {
      OriginStationId: @origin_id,
      DestStationId: @dest_id,
      HoursDeparture: @datetime.hour,
      MinutesDeparture: @datetime.minute,
      GoingTrainCln: @datetime.strftime('%Y-%m-%d'),
      GoingHourDeparture: true
    }
  end
end

CLI.new.start
