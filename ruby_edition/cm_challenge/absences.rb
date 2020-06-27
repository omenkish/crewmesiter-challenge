require_relative './api'
require_relative './members'

module CmChallenge
  class Absences
    class << self
      def to_ical
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
