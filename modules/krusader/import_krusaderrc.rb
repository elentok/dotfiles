#!/usr/bin/env ruby

# fix UTF-8 problems
require 'iconv' unless String.method_defined?(:encode)

def fix_utf8(string)
  if String.method_defined?(:encode)
    string.encode('UTF-8', 'UTF-8', :invalid => :replace)
  else
    ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
    ic.iconv(string)
  end
end

def load_ini(filename)
  header = []
  sections = [header]
  current_section = header

  File.open(filename).each do |line|
    line = fix_utf8(line)

    next if /^ *$/.match(line)

    if /^\[/.match(line)
      current_section = [line]
      sections << current_section
    else
      current_section << line
    end
  end

  sections
end

filename = File.expand_path("~/.kde/share/config/krusaderrc")
sections = load_ini(filename)

sections_to_ignore = %w{Search Startup\]\[ Private QueueManager MountMan 
  KFileMetaPropsPlugin KPropertiesDialog KFileDialog Konfigurator 
  KrViewerWindow KrInterDetailedView}
sections_to_ignore_regex = Regexp.new("^\\[(#{sections_to_ignore.join('|')})")

File.open('krusaderrc', 'w') do |f|
  sections.each do |section|
    next if sections_to_ignore_regex.match(section[0])
    section.each do |line|
      next if /^(PopularUrls|Saved State|Last State)=/.match(line)
      f.write(line)
    end
    f.write("\n")
  end
end
