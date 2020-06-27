require 'date'

module AbsencesHelper
  def generate_ical_data_from_absences(absences)
    cal = Icalendar::Calendar.new
    absences.each do |absence|
      event = cal.event
      event.dtstart = Icalendar::Values::Date.new(format_date(date: absence[:start_date]))
      event.dtend = Icalendar::Values::Date.new(format_date(date: absence[:end_date]))
      event.summary = "#{absence[:name].capitalize} absence details"
      # event.description = absence_status(absence)
      event.transp = 'TRANSPARENT'
      event.created = format_date(date: absence[:created_at], date_time: true)
    end
    cal.to_ical
  end

  def format_date(date:, date_time: false)
    # format American date type
    tokens = date.split('-')
    if tokens[1].to_i > 12
      tokens[1] = tokens[2]
      tokens[2] = tokens[1]
    end
    date = tokens.join
    return Date.parse(date) unless date_time
    DateTime.parse(date)
  end

  def write_data_to_file(path_to_file:, data:)
    File.write(path_to_file, data)
  end
end
