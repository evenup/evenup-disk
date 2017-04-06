# == Define: disk::writecache
#
# This definition allows change of write cache of a disk by using hdparm
#
#
# === Parameters
#
# [*name*]
#   String. The device to set the writecache on
#   Required
#
# [*writecache*]
#   Boolean.  Whether to turn on write cache
#   Default: 1
#
#
# === Examples
#
#   disk::writecache { 'xvde1':
#     writecache => 1
#   }
#
#
# === Authors
#
# * Stanley Zhang <mailto:stanley.zhang@ityin.net>
#
#
define disk::writecache (
  $writecache = 1
) {

  if ! defined(Class['disk']) {
    fail('You must include the disk base class before using any disk defined resources')
  }

  $has_device = inline_template("<%= '${::blockdevices}'.split(',').include?('${name}') %>")

  if str2bool($has_device) == false and $::disk::fail_on_missing_device {
    fail("Device ${name} does not exist")
  }

  $writecache_value = bool2num($writecache)
  $set_writecache_cmd = "hdparm -W${writecache_value} /dev/${name}"
  $set_writecache_match = "hdparm -W[0,1] /dev/${name}"

  disk::persist_setting { "disk_writecache_for_${name}":
    command => $set_writecache_cmd,
    path    => $::disk::bin_path,
    match   => $set_writecache_match,
    require => Package[$::disk::hdparm_package_name],
  }

  exec { "disk_writecache_for_${name}":
    command => $set_writecache_cmd,
    path    => $::disk::bin_path,
    unless  => "hdparm -W /dev/${name} | grep write-caching | grep ${writecache_value}",
    require => Package[$::disk::hdparm_package_name],
  }
}
