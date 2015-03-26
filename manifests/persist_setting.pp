# == Define: disk::persist_setting
#
# Private type for persisting a setting
#
#
# === Parameters
#
# [*command*]
#   String.  The command that will configure the setting
#   Required
#
# [*match*]
#   String.  Indicate what constitutes a setting that should be overwritten
#   Default: command
#
# [*path*]
#   String.  Set the bin path
#   Default: /bin:/usr/bin:/sbin
#
# [*persist_file*]
#   String.  Path to a file where the command will become persisted
#   Default: /etc/rc.local
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
# * Jesse Cotton <mailto:jcotton@ebay.com>
#
define disk::persist_setting (
  $command      = undef,
  $match        = undef,
  $path         = $::disk::bin_path,
  $persist_file = $::disk::persist_file,
) {

  if ! defined(Class['disk']) {
    fail('You must include the disk base class before using any disk defined resources')
  }

  validate_string($command)
  validate_absolute_path($persist_file)

  if is_array($path) {
    $_path = join($path, ':')
  }
  else {
    $_path = $path
  }

  $_command = "PATH=${_path} ${command}"

  if $match == undef {
    $_match = "^${_command}"
  }
  else {
    $_match = $match
  }

  file_line { $name:
    path  => $persist_file,
    line  => $_command,
    match => $_match,
  }
}
