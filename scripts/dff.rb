#!/usr/bin/env ruby

KEYS = [:device, :size, :used, :available, :capacity, :mount, :available_gb,
        :size_gb]

BLACK="\033[30m"
GRAY="\033[1;30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
UNDERLINE="\033[4m"
RESET="\033[0m"

class Disk
  attr_reader :device, :size, :used, :available, :capacity, :mount,
              :available_gb, :size_gb

  def initialize(parts)
    @device       = parts[0]
    @size         = parts[1].to_i
    @used         = parts[2]
    @available    = parts[3].to_i
    @capacity     = parts[4]
    @available_gb = size_to_gb(@available)
    @size_gb      = size_to_gb(@size)
    @mount        = parts.last
  end

  def size_to_gb(size)
    (size.to_f / 1024 / 1024).round(1).to_s
  end

  def state
    c = @capacity.to_i
    if c > 90
      :bad
    elsif c > 70
      :ok
    else
      :good
    end
  end

  COLORS_BY_STATE = {
    bad:  RED,
    ok:   YELLOW,
    good: GREEN
  }

  def color
    COLORS_BY_STATE[state]
  end

  def self.from_line(line)
    parts = line.strip.split(/\s+/)
    if parts[0] != 'Filesystem'
      Disk.new(parts)
    end
  end

  def show?
    (@mount =~ /\/(Volumes|media)/) || (@mount == '/')
  end
end

module Loader
  def self.disks
    output = `df`

    disks = []

    output.each_line do |line|
      disk = Disk.from_line(line)
      disks.push(disk) if disk && disk.show?
    end

    disks
  end
end

class DiskFormatter
  def initialize(disk, column_widths)
    @disk = disk
    @column_widths = column_widths
  end

  def format
    [
      @disk.color,
      rjust(:capacity),
      rjust(:available_gb) + 'G',
      'free (of',
      rjust(:size_gb) + 'G)',
      ljust(:mount),
      "#{GRAY}(#{@disk.device})",
      RESET
    ].join(' ')
  end

  def rjust(key)
    @disk.send(key).to_s.rjust(@column_widths[key])
  end

  def ljust(key)
    @disk.send(key).to_s.ljust(@column_widths[key])
  end
end

class Formatter
  def self.format(disks)
    column_widths = calculate_column_widths(disks)
    disks.map do |disk|
      DiskFormatter.new(disk, column_widths).format
    end
  end

  def self.calculate_column_widths(disks)
    column_widths = {}
    disks.each do |disk|
      KEYS.each do |key|
        width = column_widths[key] || 0
        column_widths[key] = [width, disk.send(key).to_s.length].max
      end
    end
    column_widths
  end
end

puts Formatter.format(Loader.disks)
