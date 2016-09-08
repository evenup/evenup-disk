require 'spec_helper'

describe 'disk::rotational', :type => :define do
  let(:params) { { :rotational => 'true' } }
  let(:pre_condition) { 'include disk '}

  context 'single device' do
    let(:facts) { { :blockdevices => 'xvde1' } }

    context 'valid device' do
      let(:title) { 'xvde1' }
      let(:expected_cmd) {
        [
          'test -d /sys/block/xvde1',
          'echo 1 > /sys/block/xvde1/queue/rotational'
        ].join(' && ')
      }
      it { should contain_class('disk') }
      it {
        should contain_exec('disk_rotational_for_xvde1').with({
          'command' => expected_cmd
        })
      }
      it {
        should contain_disk__persist_setting('disk_rotational_for_xvde1').with({
          'command' => expected_cmd,
          'match'   => "/sys/block/xvde1/queue/rotational"
        })
      }
    end

    context 'invalid device' do
      let(:title) { 'sda' }

      context 'set fail_on_missing_device false' do
        let(:pre_condition) { 'class { disk: fail_on_missing_device => false }' }
        it { should_not contain_exec('disk_rotational_for_sda') }
        it { should_not contain_disk__persist_setting('disk_rotational_for_sda') }
      end

      context 'set fail_on_missing_device true' do
        let(:pre_condition) { 'class { disk: fail_on_missing_device => true }' }
        it {
          expect {
            should_not contain_exec('disk_rotational_for_sda')
          }.to raise_error(Puppet::Error, /Device sda does not exist/)
        }
      end
    end

  end

  context 'multiple devices' do
    let(:facts) { { :blockdevices => 'xvde1,xvdf' } }

    context 'valid device' do
      let(:title) { 'xvde1' }
      it { should contain_exec('disk_rotational_for_xvde1') }
      it { should contain_disk__persist_setting('disk_rotational_for_xvde1') }
    end

    context 'invalid device' do
      let(:title) { 'sda' }
      it { should_not contain_exec('disk_rotational_for_sda') }
      it { should_not contain_disk__persist_setting('disk_rotational_for_sda') }
    end
  end

end

