require 'spec_helper'

describe 'disk::scheduler', :type => :define do
  let(:params) { { :scheduler => 'cfq' } }

  context 'single device' do
    let(:facts) { { :blockdevices => 'xvde1' } }

    context 'valid device' do
      let(:title) { 'xvde1' }
      it { should contain_exec('disk_scheduler_for_xvde1') }
    end

    context 'invalid device' do
      let(:title) { 'sda' }
      it { should_not contain_exec('disk_scheduler_for_sda') }
    end

  end

  context 'multiple devices' do
    let(:facts) { { :blockdevices => 'xvde1,xvdf' } }

    context 'valid device' do
      let(:title) { 'xvde1' }
      it { should contain_exec('disk_scheduler_for_xvde1') }
    end

    context 'invalid device' do
      let(:title) { 'sda' }
      it { should_not contain_exec('disk_scheduler_for_sda') }
    end
  end

end

