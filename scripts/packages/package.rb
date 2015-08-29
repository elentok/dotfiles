class Package
  attr_accessor :title, :date, :estimated, :tracking, :store
  def initialize(title, date, estimated = nil, options = {})
    @title     = title
    @tracking  = options[:tracking]
    @store     = options[:store]
    @date      = Date.parse(date)
    @estimated = DeliveryEstimation.parse(estimated)
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
    elsif days_ago < 7
      "#{days_ago} days ago"
    else
      weeks = (days_ago / 7).to_i
      if weeks == 1
        '1 week ago'
      else
        "#{weeks} weeks ago"
      end
    end
  end

  def when_to_expect
    @estimated.nil? ? 'unknown' : @estimated.when
  end
end

class DeliveryEstimation
  def initialize(from, to = nil)
    @from = from
    @to = to
  end

  def self.parse(raw)
    return nil if raw.nil?

    dates = raw.split(' - ').map { |date| Date.parse(date) }
    DeliveryEstimation.new(*dates)
  end

  def overdue?
    @to && Date.today > @to
  end

  def days_to_start_expecting
    (@from - Date.today).to_i
  end

  def when_to_start_expecting
    days = days_to_start_expecting
    if days >= 7
      weeks = (days / 7).to_i
      if weeks == 1
        'next week'
      else
        "in #{weeks} weeks"
      end
    else
      if Date.today.wday < @from.wday
        'this week'
      else
        'next week'
      end
    end
  end

  def when
    if overdue?
      'overdue'
    else
      if Date.today > @from
        'any day now'
      else
        when_to_start_expecting
      end
    end
  end
end

