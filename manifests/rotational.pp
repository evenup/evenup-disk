# == Define: disk::rotational
#
# This definition allows the setting of a disk rotational in linux.
#
#
# === Parameters
#
# [*name*]
#   String. The device to set the rotational on
#   Required
#
# [*rotational*]
#   String.  The rotational to use
#   Default: 1
#
#
# === Examples
#
#   disk::rotational { 'xvde1':
#     rotational => 1
#   }
#
#
# === Authors
#
# * Stanley Zhang <mailto:stanley.zhang@ityin.net>
#
#
define disk::rotational (
  $rotational = 1
) {

  if ! defined(Class['disk']) {
    fail('You must include the disk base class before using any disk defined resources')
  }

  $has_device = inline_template("<%= '${::blockdevices}'.split(',').include?('${name}') %>")

  if str2bool($has_device) == false and $::disk::fail_on_missing_device {
    fail("Device ${name} does not exist")
  }

  $rotational_value = bool2num($rotational)
  if str2bool($has_device) == true {
    $maybe_set_rotational = join([
      "test -d /sys/block/${name}",
      "echo ${rotational_value} > /sys/block/${name}/queue/rotational",
    ], ' && ')

    disk::persist_setting { "disk_rotational_for_${name}":
      command => $maybe_set_rotational,
      path    => $::disk::bin_path,
      match   => "/sys/block/${name}/queue/rotational",
    }

    exec { "disk_rotational_for_${name}":
      command => $maybe_set_rotational,
      path    => $::disk::bin_path,
      unless  => "grep -q '${rotational_value}' /sys/block/${name}/queue/rotational",
    }

  }

}
