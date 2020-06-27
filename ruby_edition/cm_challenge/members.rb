require_relative './api'
module CmChallenge
  class Members
    def self.find(user_id:)
      Api.members.find { |member| member[:user_id] == user_id }
    end
  end
end
