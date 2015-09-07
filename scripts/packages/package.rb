class Package
  attr_accessor :title, :date, :estimated, :tracking, :store
  def initialize(title, date, estimated = nil, options = {})
    @title     = title
    @tracking  = options[:tracking]
    @store     = options[:store]
    @date      = Date.parse(date)
    @estimated = DeliveryEstimation.parse(estimated, @date)
  end

  def to_s
    @title
  end

  def pretty_name(title_width = 0)
    [
      title.ljust(title_width),
      gray("(ordered on"),
      yellow(store),
      gray("#{time_ago})")
    ].join(' ')
  end

  def order
    if @estimated.nil?
      99999
    elsif @estimated.overdue?
      -99999
    else
      @estimated.days_to_start_expecting
    end
  end

  def days_ago
    @days_ago ||= (Date.today - @date).to_i
  end

  def time_ago
    if days_ago == 0
      'today'
    elsif days_ago == 1
      'yesterday'
    else
      weeks = (days_ago / 7).to_i
      days = days_ago - weeks * 7

      names = %w(w d)
      values = [weeks, days]

      values.map.with_index do |value, index|
        "#{value}#{names[index]}" if value > 0
      end.compact.join(' ') + ' ago'
    end
  end

  def when_to_expect
    @estimated.nil? ? When.unknown : @estimated.when
  end
end

class DeliveryEstimation
  def initialize(from, to = nil)
    @from = from
    @to = to
  end

  def self.parse(raw, order_date)
    return nil if raw.nil?

    match = /^(\d)+-(\d)+ days$/.match(raw)
    if match.nil?
      dates = raw.split(' - ').map { |date| Date.parse(date) }
    else
      dates = [
        order_date + match[1].to_i,
        order_date + match[2].to_i
      ]
    end

    DeliveryEstimation.new(*dates)
  end

  def overdue?
    @to && Date.today > @to
  end

  def days_to_start_expecting
    (@from - Date.today).to_i
  end

  def when
    if overdue?
      When.overdue
    else
      if Date.today > @from
        When.any_day_now
      else
        when_to_start_expecting
      end
    end
  end

  def when_to_start_expecting
    days = days_to_start_expecting
    if days >= 7
      weeks = (days / 7).to_i
      if weeks == 1
        When.next_week
      else
        When.in_x_weeks(weeks)
      end
    else
      if Date.today.wday < @from.wday
        When.this_week
      else
        When.next_week
      end
    end
  end

end

class When
  attr_reader :name, :order, :color

  def initialize(name, order, color = nil)
    @name = name
    @order = order
    @color = color
  end

  def to_s
    @name.to_s.gsub(/_/, ' ').capitalize
  end

  def self.add(name, order, color = nil)
    if color.nil?
      color = 'nil'
    else
      color = ":#{color}"
    end

    self.class_eval \
      "def self.#{name}; " \
      "  @@#{name} ||= When.new(:#{name}, #{order}, #{color});" \
      "end"
  end

  add :overdue,     0,   :red
  add :any_day_now, 1,   :yellow
  add :this_week,   2,   :green
  add :next_week,   3
  add :unknown,     999, :gray

  def self.in_x_weeks(x)
    @@other ||= {}
    @@other[x] ||= When.new("in_#{x}_weeks".to_sym, 3 + x)
  end
end
