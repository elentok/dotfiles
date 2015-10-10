require 'json'

class PackageExport
  def self.export(packages)
    hash = {}

    packages.each do |package|
      hash[package.title] = package.serialize
      hash[package.title].delete :title
    end

    puts hash.to_json
  end
end
