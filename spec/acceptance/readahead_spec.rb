require 'spec_helper_acceptance'

describe 'disk tuning' do
  context 'set readahead' do

    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'disk': }
      disk::readahead { 'sda': readahead => 1024 }
      EOS

      # ensure scheduler is changed
      apply_manifest(pp, :catch_failures => true)

      pp = <<-EOS
      class { 'disk': }
      disk::readahead { 'sda': readahead => 512 }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe command('blockdev --getra /dev/sda') do
      its(:stdout) { should match /512/ }
    end

  end
end
