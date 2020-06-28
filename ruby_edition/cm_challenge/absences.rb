require_relative './api'
require_relative './members'
require_relative './absences_helper'

module CmChallenge
  class Absences
    extend AbsencesHelper
    class << self
      def to_ical
        generate_ical_data_from_absences(all_with_names)
      end

      def generate_ical_file(path_to_file: 'cm_challange/absences.ics', data: to_ical)
        write_data_to_file(data: data, path_to_file: path_to_file)
      end

      def all_with_names
        absences = Api.absences
        absences.each do |absence|
          absentee = get_absentee_from_members(absentee_id: absence[:user_id])
          absence[:employee_name] = absentee[:name]
        end

        absences
      end

      def find_employee_absences(employee_id:)
        all_with_names.select { |absence| absence[:user_id] == employee_id }
      end

      def employee_vacation_status(employee:, status:)
        return "#{employee[:name]} is on #{status} leave" if is_absent?(employee_id: employee[:user_id], absence_type: status)

        "#{employee[:name]} is currently NOT absent"
      end

      private

      def get_absentee_from_members(absentee_id:)
        Members.find(user_id: absentee_id)
      end

      def is_absent?(employee_id:, absence_type:)
        employee_absences = find_employee_absences(employee_id: employee_id)
        employee_absences.any? {|absence| format_date(date: absence[:end_date]) >= Date.today && absence[:type] == absence_type}
      end
    end
  end
end
