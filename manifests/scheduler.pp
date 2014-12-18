# == Define: disk::scheduler
#
# This definition allows the setting of a disk scheduler in linux.
#
#
# === Parameters
#
# [*name*]
#   String. The device to set the scheduler on
#   Required
#
# [*scheduler*]
#   String.  The scheduler to use
#   Default: noop
#
#
# === Examples
#
#   disk::scheduler { 'xvde1':
#     scheduler       => 'deadline'
#   }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
# * Jesse Cotton <mailto:jcotton@ebay.com>
#
#
define disk::scheduler (
  $scheduler = 'noop'
) {

  if ! defined(Class['disk']) {
    fail('You must include the disk base class before using any disk defined resources')
  }

  $has_device = inline_template("<%= '${::blockdevices}'.split(',').include?('${name}') %>")

  if $has_device == 'false' and $::disk::fail_on_missing_device {
    fail("Device ${name} does not exist")
  }

  if $has_device == 'true' {

    $maybe_set_scheduler = join([
      "test -d /sys/block/${name}",
      "echo ${scheduler} > /sys/block/${name}/queue/scheduler"
    ], ' && ')

    disk::persist_setting { "disk_scheduler_for_${name}":
      command      => $maybe_set_scheduler,
      path         => $::disk::bin_path,
      match        => "/sys/block/${name}/queue/scheduler",
    }

    exec { "disk_scheduler_for_${name}":
      command => $maybe_set_scheduler,
      path    => $::disk::bin_path,
      unless  => "grep -q '\\[$scheduler\\]' /sys/block/${name}/queue/scheduler"
    }

  }

}
