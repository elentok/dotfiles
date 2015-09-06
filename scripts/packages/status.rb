class PackageStatus
  def initialize(packages)
    @packages = packages.sort_by(&:order)
  end

  def print
    @title_width = @packages.map() { |pkg| pkg.title.length }.max

    puts
    puts blue("Expecting #{@packages.length} packages:")
    puts

    @packages.group_by(&:when_to_expect)
      .sort_by { |value, _| value.order }
      .each do |when_to_expect, pkgs|
      puts green("#{when_to_expect} (#{pkgs.length} packages)")
        pkgs.sort_by(&:days_ago).reverse.each { |pkg| print_pkg(pkg) }
        puts
    end
  end

  def print_pkg(pkg)
    puts "☻ #{pkg.pretty_name(@title_width)}"
  end

  def self.print(packages)
    self.new(packages).print
  end
end

