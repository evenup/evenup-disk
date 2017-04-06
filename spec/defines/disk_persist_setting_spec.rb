require 'spec_helper'

describe 'disk::persist_setting', :type => :define do
  let(:title) { 'test' }
  let(:pre_condition) { 'include disk '}
  let(:params) {
    {
      :path         => [ "/bin", "/usr/bin", "/sbin" ],
      :persist_file => "/etc/rc.d/rc.local"
    }
  }

  context 'without a match' do
    let(:params) { { :command => "false" } }
    it {
      should contain_file_line('test').with({
          'line'  => "PATH=/bin:/usr/bin:/sbin false",
          'match' => "^PATH=/bin:/usr/bin:/sbin false",
          'path'  => "/etc/rc.d/rc.local"
      })
    }
  end

  context 'with a match' do
    let(:params) {
      {
        :command => "echo noop > /sys/block/sda/queue/scheduler",
        :match   => "/sys/block/sda/queue/scheduler"
      }
    }
    it {
      should contain_file_line('test').with({
          'line'  => "PATH=/bin:/usr/bin:/sbin echo noop > /sys/block/sda/queue/scheduler",
          'match' => "/sys/block/sda/queue/scheduler",
          'path'  => "/etc/rc.d/rc.local"
      })
    }
  end

end

