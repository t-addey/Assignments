#------exec apt-update-----#
exec { 'apt-get update':
  command => '/usr/bin/apt-get update'
}

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/bin']
}

#------Only install appserver-----#
class appserver {
  package { ['nodejs', 'curl' 'npm', 'wget']:
     ensure => present,
     require => Exec['apt-get update']
  }  
}

#-----Install dbserver and keep it running----#
class dbserver {
   package { 'mysql':
      ensure => present,
      require => Exec['apt-get update']
   }

   service { 'mysql':
      ensure => running,
      require => Package['mysql']
   }
}

#--------Using node derective------------#

node 'vm1' {
   include appserver
}

node 'vm2' {
   include dbserver
}

# --- NodeJS --- #
# Because of a package name collision, 'node' is called 'nodejs' in Ubuntu.
# Here adding a symlink so 'node' points to 'nodejs'
file { '/usr/bin/node':
  ensure => 'link',
  target => "/usr/bin/nodejs",
}