require_relative '../cm_challenge/absences'

RSpec.describe 'Absences' do
  describe '#with_names' do
    let(:absences) { CmChallenge::Absences.with_names }
    it { expect(absences).to respond_to(:each) }
    it { expect(absences).to all(have_key(:name)) }
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
end
