require 'spec_helper_acceptance'

describe 'disk tuning' do
  context 'set scheduler' do

    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'disk': }
      disk::scheduler { 'sda': scheduler => 'deadline' }
      EOS

      # ensure scheduler is changed
      apply_manifest(pp, :catch_failures => true)

      pp = <<-EOS
      class { 'disk': }
      disk::scheduler { 'sda': scheduler => 'noop' }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/sys/block/sda/queue/scheduler') do
      its(:content) { should match /\[noop\]/ }
    end

  end
end
