require 'open-uri'
require 'json'

begin
  require 'html_to_plain_text'
rescue LoadError
  puts 'Error: html_to_plain_text gem is missing, installing...'
  if system('sudo /usr/bin/gem install html_to_plain_text')
    puts
    puts 'Gem installed, please run again'
    exit 0
  else
    puts 'Error installing gem, please run again'
    exit 1
  end
end


module PackageTracker
  def self.track(packages)
    packages.select { |pkg| pkg.tracking && pkg.tracking.length > 0 }
      .each { |pkg| track_pkg(pkg) }
  end

  def self.track_pkg(pkg)
    tracker = find_tracker(pkg)
    if tracker
      puts "☻ Tracking #{pkg.pretty_name}..."
      puts tracker.track(pkg.tracking)
      puts
    end
  end

  def self.find_tracker(pkg)
    if IsraelPost.supported?(pkg.tracking)
      IsraelPost
    elsif IParcel.supported?(pkg.tracking)
      IParcel
    end
  end
end

module IsraelPost
  def self.track(number)
    open(url(number)) do |f|
      body = f.read
      html = JSON.parse(body)['itemcodeinfo']

      text = HtmlToPlainText.plain_text(html)

      if text =~ /postal item was delivered/
        text = green(text)
      elsif !(text =~ /There is no information/)
        text = blue(text)
      else
        text = gray(text)
      end

      text
    end
  end

  def self.supported?(number)
    number =~ /^[A-Z]{2}\d{9}[A-Z]{2}$/ ||
      number =~ /^\d{13}$/
  end

  def self.url(number)
    'http://www.israelpost.co.il/itemtrace.nsf/trackandtraceJSON' \
      "?openagent&_=1372171578320&lang=EN&itemcode=#{number}"
  end
end

module IParcel
  REGEX = /class="currEvent[^>]+>([^<]+)/.freeze

  def self.track(number)
    url = "https://tracking.i-parcel.com/?TrackingNumber=#{number}"
    html = `curl --silent '#{url}'`
    puts REGEX.match(html)[1].strip
  end

  def self.supported?(number)
    number =~ /^AG/
  end
end
