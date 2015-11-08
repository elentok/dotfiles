COLORS = {
  black:     "\033[30m",
  gray:      "\033[1;30m",
  red:       "\033[31m",
  green:     "\033[32m",
  yellow:    "\033[33m",
  blue:      "\033[34m",
  cyan:      "\033[36m"}

RESET = "\033[0m"

require 'optparse'

class Object
  COLORS.each do |name, value|
    define_method name do |text|
      [value, text, RESET].join()
    end
  end
end

def confirm?(question, default = 'no')
  ask?("#{question} (yes/no)?", default) =~ /^(y|yes)$/
end

def ask?(question, default = nil)
  STDOUT.write "#{question} "
  STDOUT.write "[#{default}] " unless default.nil?
  answer = STDIN.readline.strip

  answer == '' ? default : answer
end

def require_or_install_gem(pkg, gem_name)
  begin
    require pkg
  rescue LoadError
    puts "Error: #{gem_name} gem is missing, installing... "
    if system('sudo /usr/bin/gem install #{gem_name}')
      puts
      puts 'Gem installed, please run again'
      exit 0
    else
      puts 'Error installing gem, please run again'
      exit 1
    end
  end
end

def parse_cli_options(format)
  {}.tap do |options|
    parser = OptionParser.new do |opts|
      opts.banner = "#{format[:desc]}\n\n" \
        "Usage:\n    #{format[:usage]}\n\n" \
        "Options:\n"

      format[:options].each do |name, attribs|
        opts.on(*attribs) do
          options[name] = true
        end
      end
    end

    parser.parse!
    min_items = format[:min_items] || 0
    if ARGV.length < min_items
      puts parser.help
      exit 1
    end
  end
end
