module ReportHelper
  def date_range_formatter(range)
    range.try(:first).try(:strftime, '%m/%d/%Y') || 'Invalid Date'
  end
end
