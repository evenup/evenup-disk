require 'spec_helper'

describe 'disk::scheduler', :type => :define do
  let(:params) { { :scheduler => 'cfq' } }

  context 'single device' do
    let(:facts) { { :blockdevices => 'xvde1' } }

    context 'valid device' do
      let(:title) { 'xvde1' }
      let(:expected_cmd) {
        [
          "/usr/bin/test -d /sys/block/xvde1",
          "/bin/grep --quiet '\\[cfq\\]' /sys/block/xvde1/queue/scheduler",
          "/bin/echo cfq > /sys/block/xvde1/queue/scheduler"
        ].join(" && ")
      }
      it { should contain_class('disk') }
      it {
        should contain_exec('disk_scheduler_for_xvde1').with({
          'command' => expected_cmd
        })
      }
      it {
        should contain_file_line('disk_scheduler_for_xvde1').with({
          'path'  => "/etc/rc.local",
          'line'  => expected_cmd,
          'match' => "^/usr/bin/test -d /sys/block/xvde1"
        })
      }
    end

    context 'invalid device' do
      let(:title) { 'sda' }

      context 'set fail_on_missing_device false' do
        let(:params) { { :fail_on_missing_device => false } } 
        it { should_not contain_exec('disk_scheduler_for_sda') }
        it { should_not contain_file_line('disk_scheduler_for_sda') }
      end

      context 'set fail_on_missing_device true' do
        let(:params) { { :fail_on_missing_device => true } }
        it { 
          expect { 
            should_not contain_exec('disk_scheduler_for_sda')
          }.to raise_error(Puppet::Error, /Device sda does not exist/)
        }
      end
    end

  end

  context 'multiple devices' do
    let(:facts) { { :blockdevices => 'xvde1,xvdf' } }

    context 'valid device' do
      let(:title) { 'xvde1' }
      it { should contain_exec('disk_scheduler_for_xvde1') }
      it { should contain_file_line('disk_scheduler_for_xvde1') }
    end

    context 'invalid device' do
      let(:title) { 'sda' }
      it { should_not contain_exec('disk_scheduler_for_sda') }
      it { should_not contain_file_line('disk_scheduler_for_sda') }
    end
  end

end

