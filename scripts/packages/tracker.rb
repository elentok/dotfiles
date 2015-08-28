require 'open-uri'
require 'json'

module PackageTracker
  def self.track(packages)
    packages.select { |pkg| pkg.tracking && pkg.tracking.length > 0 }
      .each { |pkg| track_pkg(pkg) }
  end

  def self.track_pkg(pkg)
    if IsraelPost.supported?(pkg.tracking)
      puts "☻ Tracking #{pkg.pretty_name}..."
      puts IsraelPost.track(pkg.tracking)
    end
  end
end

module IsraelPost
  def self.track(number)
    open(url(number)) do |f|
      body = f.read
      JSON.parse(body)['itemcodeinfo'].split('<br>').first
    end
  end

  def self.supported?(number)
    number =~ /^[A-Z]{2}\d{9}[A-Z]{2}$/
  end

  def self.url(number)
    "http://www.israelpost.co.il/itemtrace.nsf/trackandtraceJSON" +
      "?openagent&_=1372171578320&lang=EN&itemcode=#{number}"
  end
end
