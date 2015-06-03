class nfs {

  case $osfamily {
    'Debian': {
      package { 'nfs-common':
        ensure => present,
      }
    }
    'RedHat': {
      package { 'nfs-utils':
        ensure => present,
      }
    }
  }
}


define nfs_mount($remote) {
  include nfs

  $mountpoint = $name

  $nfs_args = "-t nfs -o rw,nolock,nfsvers=3"

  file { $mountpoint:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  exec { "nfs mount: ${mountpoint}":
    command   => "mount ${nfs_args} ${remote} ${mountpoint}",
    path      => "/usr/bin:/bin:/usr/sbin:/bin",
    unless    => "grep \"${mountpoint}\" /proc/mtab",
    logoutput => on_failure,
    require   => File[$mountpoint],
  }
}

nfs_mount { "/projects":
  remote => "10.20.1.1:/home/adrien/puppetlabs/eng/projects",
}
