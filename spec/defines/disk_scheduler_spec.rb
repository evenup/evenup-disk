require 'spec_helper'

describe 'disk::scheduler', :type => :define do
  let(:title) { 'sda' }
  let(:params) { { :scheduler => 'cfq' } }

  it { should contain_exec('disk_scheduler_for_sda') }

end

