#------exec apt-update-----#
exec { 'apt-get update':
  command => '/usr/bin/apt-get update'
}

#------Only install appserver-----#
class appserver {
  package { 'nodejs':
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