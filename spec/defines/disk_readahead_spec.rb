require 'spec_helper'

describe 'disk::readahead', :type => :define do
  let(:params) { { :readahead => 2048 } }

  context 'single device' do
    let(:facts) { { :blockdevices => 'xvde' } }

    context 'valid device' do
      let(:title) { 'xvde' }
      let(:expected_cmd) {
        [
          'test -d /sys/block/xvde',
          'blockdev --setra 2048 /dev/xvde'
        ].join(' && ')
      }
      it { should contain_class('disk') }
      it {
        should contain_exec('disk_readahead_for_xvde').with({
          'command' => expected_cmd
        })
      }
      it {
        should contain_disk__persist_setting('disk_readahead_for_xvde').with({
          'command' => expected_cmd,
          'match'   => "blockdev\\s--setra\\s[0-9]+\\s/dev/xvde"
        })
      }
    end

    context 'invalid device' do
      let(:title) { 'sda' }

      context 'set fail_on_missing_device false' do
        let(:pre_condition) { 'class { disk: fail_on_missing_device => false }' }
        it { should_not contain_exec('disk_readahead_for_sda') }
        it { should_not contain_disk__persist_setting('disk_readahead_for_sda') }
      end

      context 'set fail_on_missing_device true' do
        let(:pre_condition) { 'class { disk: fail_on_missing_device => true }' }
        it {
          expect {
            should_not contain_exec('disk_readahead_for_sda')
          }.to raise_error(Puppet::Error, /Device sda does not exist/)
        }
      end
    end

  end

  context 'multiple devices' do
    let(:facts) { { :blockdevices => 'xvde,xvdf' } }

    context 'valid device' do
      let(:title) { 'xvde' }
      it { should contain_exec('disk_readahead_for_xvde') }
      it { should contain_disk__persist_setting('disk_readahead_for_xvde') }
    end

    context 'invalid device' do
      let(:title) { 'sda' }
      it { should_not contain_exec('disk_readahead_for_sda') }
      it { should_not contain_disk__persist_setting('disk_readahead_for_sda') }
    end
  end

end

