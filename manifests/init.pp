# == Class: docker
#
# Manage Docker
#
class docker (
  $rpm_url            = 'https://get.docker.com/rpm/1.7.1/centos-7/RPMS/x86_64/docker-engine-1.7.1-1.el7.centos.x86_64.rpm',
  $socket_group       = 'docker',
  $manage_group_users = undef,
  $images             = undef,
) {

  if $::osfamily != 'RedHat' and $::operatingsystemmajrelease != '7' {
    fail("Docker is only supported on EL 7. Your osfamily is <${::osfamily}> and your operatingsystemmajrelease is identified as <${::operatingsystemmajrelease}>.")
  }

  package { 'docker-engine':
    ensure   => installed,
    provider => 'rpm',
    source   => $rpm_url,
  }

  file { 'etc_docker_service_d_dir':
    ensure => directory,
    path   => '/etc/systemd/system/docker.service.d',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  group { 'docker_group':
    ensure     => present,
    name       => $socket_group,
    forcelocal => true,
  }

  exec { 'systemd_reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  service { 'docker_service':
    ensure   => running,
    name     => 'docker',
    enable   => true,
    provider => 'systemd',
  }

  if $manage_group_users != undef {
    validate_hash($manage_group_users)

    create_resources('docker::conf::user', $manage_group_users)
  }

  if $images != undef {
    validate_hash($images)

    create_resources('docker::image', $images)
  }
}
