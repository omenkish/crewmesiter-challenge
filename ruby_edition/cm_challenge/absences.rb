require_relative './api'
require_relative './members'
require_relative './absences_helper'

module CmChallenge
  class Absences
    extend AbsencesHelper
    class << self
      def to_ical
        generate_ical_data_from_absences(with_names)
      end

      def generate_ical_file(path_to_file:, data: to_ical)
        write_data_to_file(data: data, path_to_file: path_to_file)
      end

      def with_names
        absences = Api.absences
        absences.each do |absence|
          absent_member = get_absentee_from_members(absentee_id: absence[:user_id])
          absence[:name] = absent_member[:name]
        end

        absences
      end

      private

      def get_absentee_from_members(absentee_id:)
        Members.find(user_id: absentee_id)
      end
    end
  end
end
