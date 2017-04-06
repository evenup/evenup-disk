require 'spec_helper'

describe 'disk::writecache', :type => :define do
  let(:facts) { { :blockdevices => 'sda,xvda' } }
  let(:pre_condition) { 'include disk' }
  let(:hdparm_package_name) { 'hdparm' }

  context 'valid device' do
    let(:title) { 'xvda' }
    let(:params) { { :writecache => 'yes' } }
    let(:exec_title) { "disk_writecache_for_#{title}" }

    it { is_expected.to contain_class('disk') }
    it { is_expected.to contain_disk__persist_setting(exec_title)
      .with({
      :command => 'hdparm -W1 /dev/xvda',
      :match => 'hdparm -W[0,1] /dev/xvda'
    }).that_requires("Package[#{hdparm_package_name}]")} 
    it { is_expected.to contain_exec(exec_title)
      .with({
      :command => 'hdparm -W1 /dev/xvda',
      :unless => 'hdparm -W /dev/xvda | grep write-caching | grep 1'
    }).that_requires("Package[#{hdparm_package_name}]")} 
  end

  context 'invalid device' do
    let(:title) { 'xvdb' }
    let(:params) { { :writecache => false } }

    context 'with fail_on_missing_device to false' do
      let(:pre_condition) { 'class { disk: fail_on_missing_device => false }' }
      it { is_expected.not_to raise_error Puppet::Error, /xvdb does not exist/ }
    end

    context 'with fail_on_missing_device to true' do
      let(:pre_condition) { 'class { disk: fail_on_missing_device => true }' }
      it { is_expected.to raise_error Puppet::Error, /xvdb does not exist/ }
    end
  end
end
