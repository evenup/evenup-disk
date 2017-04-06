require 'spec_helper_acceptance'

describe 'disk tuning' do
  context 'set rotational' do

    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'disk': }
      disk::rotational { 'sda': rotational => 1 }
      EOS

      # ensure rotational is changed
      apply_manifest(pp, :catch_failures => true)

      pp = <<-EOS
      class { 'disk': }
      disk::rotational { 'sda': rotational => false }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/sys/block/sda/queue/rotational') do
      its(:content) { should eql "0\n" }
    end

  end
end
