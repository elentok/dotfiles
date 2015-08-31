require_relative './package'

class PackageReader
  def initialize(filename)
    @filename = filename
    @store = nil
    @packages = []
  end

  def read
    instance_eval File.read(@filename), @filename
    @packages
  end

  def store(name, &block)
    @store = name
    yield self
    @store = nil
  end

  def arrived(&block)
  end

  def pkg(title, date, estimated = nil, options = {})
    (options ||= {}).merge!(store: @store)
    @packages << Package.new(title, date, estimated, options)
  end

  def self.read(filename)
    filename = File.expand_path(filename)
    self.new(filename).read
  end
end

