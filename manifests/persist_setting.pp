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
# * Jesse Cotton <mailto:jcotton@ebay.com>
#
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
define disk::persist_setting (
  $command        = undef,
  $match          = undef,
  $path           = [ '/bin', '/usr/bin', '/sbin' ],
  $persist_file   = '/etc/rc.local'
) {

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
    match => $_match
  }
}
