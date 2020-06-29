require 'json'
require_relative './absences'
require 'pry'

class Router
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def route!
    path = @request.path_info
    query_string = @request.query_string

    return not_found unless path == '' || path == '/'

    unless query_string
      params = {
          "type"=> "application/calendar; charset=utf-8",
          "disposition" => " attachment; filename=\"absences.ics\""
      }
      return [200, { "Content-Type"=> params['type'], "Content-disposition" => params['disposition']}, [CmChallenge::Absences.to_ical]]
    end

    if query_string_is_correct?(query_string: query_string)
      return get_user_absences(query_string: query_string) if query_string.start_with?('userId')

      get_absences_from_query_string(query_string: query_string)
    else
      not_found
    end
  end

  private

  def get_user_absences(query_string:)
    employee_id = get_integer_from_query(query: query_string)
    data = CmChallenge::Absences.find_employee_absences(employee_id: employee_id)

    [200, { "Content-Type" => "application/json"}, [respond_with_object(object: data)]]
  end

  def get_absences_from_query_string(query_string:)
    dates = get_start_and_end_dates_from_query(query_string: query_string)
    data = CmChallenge::Absences.between(start_date: dates[:start_date], end_date: dates[:end_date])
    [200, { "Content-Type" => "application/json"}, [respond_with_object(object: data)]]
  end

  def respond_with_object(object:)
    JSON.generate(object)
  end

  def not_found(message = "Not Found")
    [404, { "content-Type" => "application/json" }, [message]]
  end

  def query_string_is_correct?(query_string:)
    return false unless query_string.start_with?('userId') || query_string.start_with?('startDate')

    true
  end

  def get_integer_from_query(query: )
    tokens = query&.split('=')
    return false if tokens.length != 2

    tokens[1].to_i
  end

  def get_start_and_end_dates_from_query(query_string:)
    tokens = query_string&.split('&')
    start_date = tokens[0]&.split('=').last
    end_date = tokens[1]&.split('=').last

    {start_date: start_date, end_date: end_date}
  end
end
