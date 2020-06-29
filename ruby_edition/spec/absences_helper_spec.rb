require_relative '../cm_challenge/absences_helper'

RSpec.describe 'AbsencesHelper' do
  include AbsencesHelper

  describe '#format_date' do
    it 'parses CET date string to instance of Date' do
      date = format_date(date: '2017-12-13')
      expect(date).to be_an_instance_of(Date)
    end
    it 'parses ET date string to an instance of Date' do
      date = format_date(date: '2017-30-01')
      expect(date).to be_an_instance_of(Date)
    end
    it 'parses ET date string to an instance of Date' do
      date = format_date(date: '2017-01-03T17:39:50.000+01:00', date_time: true)
      expect(date).to be_an_instance_of(DateTime)
    end
  end

  describe '#write_data_to_file' do
    it 'writes data to file' do
      allow(File).to receive(:write)
      write_data_to_file(file_name: 'new_path.txt', data: 'I am being written to new path')
      expect(File).to have_received(:write).once
    end
  end
end
