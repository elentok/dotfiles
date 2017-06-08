#!/usr/bin/env ruby
#
# Usage:
#
#   iparcel ask {tracking-number}
#   iparcel track {tracking-number}

require 'uri'
require "#{ENV['DOTF']}/framework.rb"

class CLI < BaseCLI
  def ask(number)
    mailto 'customer.service@i-parcel.com',
           subject: 'Local carrier tracking number',
           body: "Hi\n" \
                 'Can I please get the local carrier tracking number for ' \
                 "#{number}?" \
                 "\n\nThanks and best regards,\nDavid."
  end

  REGEX = /class="currEvent[^>]+>([^<]+)/.freeze

  def track(number)
    url = "https://tracking.i-parcel.com/?TrackingNumber=#{number}"
    html = `curl --silent '#{url}'`
    puts REGEX.match(html)[1]
  end

  def usage
    system("usage #{__FILE__}")
  end
end

CLI.new.start
