# vim: foldmethod=marker

require 'net/http'
require 'optparse'
require 'singleton'
require 'yaml'

# Colors {{{1
COLORS = {
  black:     "\033[30m",
  gray:      "\033[1;30m",
  red:       "\033[31m",
  green:     "\033[32m",
  yellow:    "\033[33m",
  blue:      "\033[34m",
  cyan:      "\033[36m"}

RESET = "\033[0m"

class Object
  COLORS.each do |name, value|
    define_method name do |text|
      [value, text, RESET].join()
    end
  end
end

# Ask/Confirm {{{1

def confirm?(question, default = 'no')
  ask("#{question} (yes/no)?", default) =~ /^(y|yes)$/
end

def ask(question, default = nil)
  STDOUT.write "#{question} "
  STDOUT.write "[#{default}] " unless default.nil?
  answer = STDIN.readline.strip

  answer == '' ? default : answer
end

# Require or install {{{1

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

# Class Options {{{1

module ClassOptions
  def class_options(*names)
    names.each do |name|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{name}(value)
          self.instance_variable_set(:@#{name}, value)
        end

        def #{name}
          self.class.instance_variable_get(:@#{name})
        end
      RUBY
    end
  end
end

# CLI {{{1
class OptionsCLI
  extend ClassOptions

  class_options :desc, :usage, :min_items, :cli_options

  attr_reader :options, :format

  def initialize
    @options = {}
    parser.parse!
    if min_items && ARGV.length < min_items
      puts parser.help
      exit 1
    end
  end

  def start
    fail Error, 'Implement me'
  end

  def parser
    @parser ||= create_parser
  end

  private

  def create_parser
    OptionParser.new do |opts|
      opts.banner = "#{desc}\n\n" \
        "Usage:\n    #{usage}\n\n" \
        "Options:\n"

      cli_options.each do |name, attribs|
        opts.on(*attribs) do |value|
          @options[name] = value
        end
      end
    end
  end
end

class BaseCLI
  def start
    cmd = ARGV.first
    ARGV.shift
    cmd = cmd.gsub(/-/, '_') if cmd

    if cmd && respond_to?(cmd)
      send(cmd, *ARGV)
    else
      usage
    end
  end
end

# HttpClient {{{1
class HttpClient
  attr_reader :headers

  def initialize(host, options = {})
    @host = host
    @port = options[:port]
    @default_req_options = options[:req] || {}
    @headers = options[:headers] || {}
  end

  def get(path, options = {})
    make_request Net::HTTP::Get.new(path), options
  end

  def post(path, body, options = {})
    req = Net::HTTP::Post.new(path)
    if body.is_a? Hash
      req.body = body.to_json
      req.content_type = 'application/json'
    else
      req.body = body
    end
    make_request(req, options)
  end

  private

  def make_request(req, options)
    options = @default_req_options.merge(options)

    req.basic_auth(*options[:basic_auth]) if options[:basic_auth]
    @headers.each { |name, value| req[name] = value }

    Net::HTTP.new(@host, @port).start do |http|
      http.request(req)
    end
  end
end

# FileCache {{{1
class FileCache
  include Singleton

  CACHE_DIR = File.expand_path('~/.cache/dotfiles')

  def initialize
    Dir.mkdir(CACHE_DIR) unless Dir.exist?(CACHE_DIR)
  end

  def fetch(name, &block)
    filename = File.join(CACHE_DIR, name)
    if File.exist?(filename)
      load_from_cache(filename)
    else
      yield.tap { |value| save_to_cache(value, filename) }
    end
  end

  def load_from_cache(filename)
    if yaml?(filename)
      YAML.load_file(filename)
    else
      File.open(filename).read
    end
  end

  def save_to_cache(value, filename)
    File.open(filename, 'w') do |f|
      value = YAML.dump(value) if yaml?(filename)
      f.write(value)
    end
  end

  def yaml?(filename)
    ['.yml', '.yaml'].include? File.extname(filename)
  end

  def self.fetch(name, &block)
    instance.fetch(name, &block)
  end
end

