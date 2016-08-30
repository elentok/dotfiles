require 'yaml'
require_relative './package'

class PackageReader
  def self.read(filename)
    filename = File.expand_path(filename)
    packages = []

    YAML.load_file(filename).map do |store, store_packages|
      store_packages.each do |title, options|
        packages << Package.new(title, store, options)
      end
    end

    packages
  end
end
