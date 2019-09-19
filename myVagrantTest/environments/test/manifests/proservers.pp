#------exec apt-update-----#
exec { 'apt-get update':
  command => '/usr/bin/apt-get update'
}

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/bin']
}

#------Only install appserver-----#
class appserver {
  package { ['nodejs', 'curl', 'npm']:
     ensure => present,
     require => Exec['apt-get update']
  }  
}

#----Install web server and keep it running---#
class web {
  package { 'nginx':
     ensure => present,
     require => Exec['apt-get update']
  }

  service { 'nginx':
     ensure => running,
     require => Package['nginx']
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
node 'web' {
   include web
}

node 'appserver' {
   include appserver
}

node 'dbserver' {
   include dbserver
}

#----Run just apt-get update on the other servers----#
node 'tst0', 'tst1', 'tst2' {
   require => Exec['apt-get update']
}

# --- NodeJS --- #
# Because of a package name collision, 'node' is called 'nodejs' in Ubuntu.
# Here adding a symlink so 'node' points to 'nodejs'
file { '/usr/bin/node':
  ensure => 'link',
  target => "/usr/bin/nodejs",
}
