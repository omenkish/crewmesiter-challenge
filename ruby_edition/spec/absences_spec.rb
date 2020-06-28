require_relative '../cm_challenge/absences'
require_relative '../cm_challenge/api'

RSpec.describe CmChallenge::Absences do
  describe '#all_with_names' do
    let(:absences) { CmChallenge::Absences.all_with_names }
    it { expect(absences).to respond_to(:each) }
    it { expect(absences).to all(have_key(:employee_name)) }
  end

  describe '#to_ical' do
    let(:ical) { CmChallenge::Absences.to_ical }
    it 'generates data in ical format' do
      expect(ical).to include("BEGIN:VCALENDAR\r\n")
      expect(ical).to include("END:VCALENDAR")
    end
  end

  describe '#generate_ical_file' do
    it 'reads to .ical file' do
      allow(File).to receive(:write)
      CmChallenge::Absences.generate_ical_file(path_to_file: 'hello.ical', data: 'ical data')
      expect(File).to have_received(:write).with('hello.ical', 'ical data').once
    end
  end

  describe '#find_employee_absences' do
    let(:absentee) { CmChallenge::Api.members.first }
    let(:employee_absences) { CmChallenge::Absences.find_employee_absences(employee_id: absentee[:user_id]) }

    it { expect(employee_absences).to respond_to(:each) }
    it { expect(employee_absences).to all(have_key(:id)) }
    it { expect(employee_absences).to all(have_key(:employee_name)) }
    it { expect(employee_absences).to all(have_key(:user_id)) }
  end

  describe '#employee_vacation_status' do
    let(:employee) { CmChallenge::Api.members.first }
    let(:absence_status) { CmChallenge::Absences.employee_vacation_status(employee: employee, status: 'vacation') }

    it 'prints current leave status of employee' do
      expect(absence_status).to eq("#{employee[:name]} is currently NOT absent")
    end
  end

  describe '#between' do
    let(:response) { CmChallenge::Absences.between(start_date: '2017-02-10', end_date: '2017-12-12') }
    it 'returns a list of absences between two dates' do
      expect(response).to respond_to(:each)
    end
    it { expect(response).to all(have_key(:id)) }

    context 'when no data matches the search query' do
      let(:response) { CmChallenge::Absences.between(start_date: '2020-02-10', end_date: '2020-12-12') }
      it 'returns an empty array' do
        expect(response).to respond_to(:each)
      end

      it { expect(response).to be_empty }
    end
  end
end
