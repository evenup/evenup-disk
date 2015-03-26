# == Define: disk::readahead
#
# This definition allows the setting of a disk readahead value in Linux.
#
#
# === Parameters
#
# [*name*]
#   String. The device to set the readahead value on
#   Required
#
# [*readahead*]
#   Int. The readahea value in 512-byte sectors
#   Default: 2048
#
# === Examples
#
#   disk::readahead { 'xvde':
#     readahead => 2048
#   }
#
#
# === Authors
#
# * Jesse Cotton <mailto:jcotton@ebay.com>
#
#
define disk::readahead (
  $readahead = 2048
) {

  if ! defined(Class['disk']) {
    fail('You must include the disk base class before using any disk defined resources')
  }

  if ! is_integer($readahead) {
    fail("[Disk::Readahead::${name}]: Readahead value ${readahead} should be an integer")
  }

  $has_device = inline_template("<%= '${::blockdevices}'.split(',').include?('${name}') %>")

  if str2bool($has_device) == false and $::disk::fail_on_missing_device {
    fail("Device ${name} does not exist")
  }

  if str2bool($has_device) == true {
    $maybe_set_readahead = join([
      "test -d /sys/block/${name}",
      "blockdev --setra ${readahead} /dev/${name}",
    ], ' && ')

    disk::persist_setting { "disk_readahead_for_${name}":
      command => $maybe_set_readahead,
      path    => $::disk::bin_path,
      match   => "blockdev\\s--setra\\s[0-9]+\\s/dev/${name}",
    }

    exec { "disk_readahead_for_${name}":
      command => $maybe_set_readahead,
      path    => $::disk::bin_path,
      unless  => "blockdev --getra /dev/${name} | grep -q ${readahead}",
    }

  }

}
