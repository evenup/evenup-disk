require 'spec_helper_acceptance'

describe 'disk tuning' do
  context 'set writecache' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'disk': }
      disk::writecache { 'sda': writecache => 'yes' }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    it 'should work as expected' do
      pp = <<-EOS
      class { 'disk': }
      disk::writecache { 'sda': writecache => 'no' }
      EOS
      # ensure writecache is changed
      apply_manifest(pp, :catch_failures => true)

      # Check running settings
      # Disable running check because Virtualbox doesn't allow
      # diskcache to be disabled
      # cache_status = shell(
      #  'hdparm -W /dev/sda | grep write-caching | awk \'{print $3}\'')
      # expect(cache_status.output.chomp.to_i).to eq 0

      # Verify persistent settings
      rc_local_content = shell('cat /etc/rc.local') 
      expect(rc_local_content.output).to match /hdparm -W0 \/dev\/sda/
    end
  end
end
