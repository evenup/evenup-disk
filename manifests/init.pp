# == Define: disk
#
# Allow the configuration of certain disk parameters
#
#
# === Parameters
#
# [*fail_on_missing_device*]
#   Bool. Whether a missing device is considered to be a fatal condition
#   Default: false
#
# [*persist_file*]
#   String.  Where to write commands to persist non-persistent settings
#   Default: /etc/rc.local
#
# [*bin_path*]
#   Array|String.  ???
#
# === Examples
#
#   class { disk':
#     fail_on_missing_device => true,
#     persist_file           => '/etc/rc.local',
#     bin_path               => ["/bin", "/usr/bin", "/sbin"]
#   }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
# * Jesse Cotton <mailto:jcotton@ebay.com>
#
class disk (
  $fail_on_missing_device = $::disk::params::fail_on_missing_device,
  $persist_file           = $::disk::params::persist_file,
  $bin_path               = $::disk::params::bin_path,
  $hdparm_package_name    = $::disk::params::hdparm_package_name,
  $hdparm_package_ensure  = $::disk::params::hdparm_package_ensure,
) inherits disk::params {

  validate_bool($fail_on_missing_device)
  validate_absolute_path($persist_file)

  unless defined(Package[$hdparm_package_name]) {
    package { $hdparm_package_name:
      ensure => $hdparm_package_ensure,
    }
  }
}
