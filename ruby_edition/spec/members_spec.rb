require_relative '../cm_challenge/members'
require_relative '../cm_challenge/api'

RSpec.describe CmChallenge::Members do
  describe '#find' do
    let(:member) { CmChallenge::Api.members.first }

    it 'finds a member by id' do
      response = CmChallenge::Members.find(user_id: member[:user_id])

      expect(response).to eq(member)
    end
  end
end

