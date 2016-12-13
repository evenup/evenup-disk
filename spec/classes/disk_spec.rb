require 'spec_helper'

describe 'disk', :type => :class do
  context 'hdparm' do
    context 'pre-defined' do
      let(:pre_condition) { 'package { hdparm: ensure => 0.2 }' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('hdparm').with_ensure('0.2') }
    end
    context 'not defined' do
      it { is_expected.to contain_package('hdparm').with_ensure('present') }
    end
  end
end
