# == Define: disk::params
#
#
# Contains default settings
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
# * Jesse Cotton <mailto:jcotton@ebay.com>
#
class disk::params {

  $fail_on_missing_device = false
  $persist_file           = '/etc/rc.d/rc.local'
  $bin_path               = ['/bin', '/usr/bin', '/sbin']

  $hdparm_package_name    = 'hdparm'
  $hdparm_package_ensure  = 'present'
}
