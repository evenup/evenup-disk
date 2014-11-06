# == Define: disk::scheduler
#
# This definition allows the setting of a disk scheduler in linux.  It will
# persist this configuration by adding a line to /etc/rc.local.
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
# [*fail_on_missing_device*]
#   Bool. Whether a missing device is considered to be a fatal condition
#   Default: false
#
#
# === Examples
#
#   disk::scheduler { 'xvde1':
#     scheduler       => 'deadline',
#     fail_on_missing => true
#   }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
# * Jesse Cotton <mailto:jcotton@ebay.com>
#
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
define disk::scheduler (
  $scheduler              = 'noop',
  $fail_on_missing_device = false
) {

  include ::disk

  $has_device = inline_template("<%= '${::blockdevices}'.split(',').include?('${name}') %>")

  if $has_device == 'false' and $fail_on_missing_device {
    fail("Device ${name} does not exist")
  }

  if $has_device == 'true' {

    $maybe_set_scheduler = join([
      "/usr/bin/test -d /sys/block/${name}",
      "/bin/grep --quiet '\\[${scheduler}\\]' /sys/block/${name}/queue/scheduler",
      "/bin/echo ${scheduler} > /sys/block/${name}/queue/scheduler"
    ],' && ')

    file_line { "disk_scheduler_for_${name}":
      path  => $::disk::persist_file,
      line  => $maybe_set_scheduler,
      match => "^/usr/bin/test -d /sys/block/${name}"
    } ~>
    exec { "disk_scheduler_for_${name}":
      command     => $maybe_set_scheduler,
      refreshonly => true
    }

  }
}
