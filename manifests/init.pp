# == Define: disk
#
# Allow the configuration of certain disk parameters
#
#
# === Parameters
#
# [*persist_file*]
#   String. Where to write commands to persist non-persistent settings
#   Default: /etc/rc.local
#
#
# === Examples
#
#   class { disk':
#     persist_file => '/etc/rc.local'
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
class disk (
  $persist_file = $::disk::params::persist_file
) inherits disk::params {

  validate_absolute_path($persist_file)
}
