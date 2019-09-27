# execute 'apt-get update'
exec { 'apt-update':                    
  command => '/usr/bin/apt-get update' 
}

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/bin']
}

# --- Preinstall Stage ---#

stage { 'preinstall':
  before => Stage['main']
}

# Define the install_packages class
class install_packages {
  package { ['curl', 'nodejs', 'npm', 'wget']:
    ensure => present
  }
}

# Declare (invoke) install_packages
class { 'install_packages':
  stage => preinstall
}

# --- NodeJS --- #
# Because of a package name collision, 'node' is called 'nodejs' in Ubuntu.
# Here we're adding a symlink so 'node' points to 'nodejs'
file { '/usr/bin/node':
  ensure => 'link',
  target => "/usr/bin/nodejs",
}