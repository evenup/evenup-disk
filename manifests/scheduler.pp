# == Define: disk::scheduler
#
# This definition allows the setting of a disk scheduler in linux.  It does not
# make it a persistent setting (which is a grub modification) but instead
# relies on the ability to change it dynamically on modern kernels on the next
# puppet run.
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
#   disk::scheduler { 'xvde1': scheduler => 'deadline' }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
define disk::scheduler (
  $scheduler  = 'noop',
) {

  $has_device = inline_template("<%= '${::blockdevices}'.split(',').include?('${name}') %>")

  if $has_device == 'true' {
    exec { "disk_scheduler_for_${name}":
      command => "echo ${scheduler} >  /sys/block/${name}/queue/scheduler",
      path    => '/bin:/usr/bin',
      unless  => "test -d /sys/block/${name}/ && grep --quiet '\\[${scheduler}\\]' /sys/block/${name}/queue/scheduler"
    }
#  } else {
#    notify { "Device ${name} not found (devices: ${::blockdevices})": }
  }

}
