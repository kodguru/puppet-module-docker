# == Class: docker
#
# Manage Docker
#
class docker (
  $repo_url           = 'USE_DEFAULTS',
  $repo_key           = 'USE_DEFAULTS',
  $package_name       = 'USE_DEFAULTS',
  $socket_group       = 'docker',
  $manage_group_users = undef,
  $images             = undef,
) {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '7': {
          $default_repo_url     = 'https://yum.dockerproject.org/repo/main/centos/7'
          $default_repo_key     = 'https://yum.dockerproject.org/gpg'
          $default_package_name = 'docker-engine'
        }
        default: {
          fail("Docker supports RedHat like systems with major release of 7 and you have <${::operatingsystemmajrelease}>.")
        }
      }
    }
    default: {
      fail("Docker is only supported on EL. Your osfamily is <${::osfamily}>.")
    }
  }

  if $repo_url == 'USE_DEFAULTS' {
    $repo_url_real = $default_repo_url
  } else {
    $repo_url_real = $repo_url
  }
  validate_string($repo_url_real)

  if $repo_key == 'USE_DEFAULTS' {
    $repo_key_real = $default_repo_key
  } else {
    $repo_key_real = $repo_key
  }
  validate_string($repo_key_real)

  if $package_name == 'USE_DEFAULTS' {
    $package_name_real = $default_package_name
  } else {
    $package_name_real = $package_name
  }
  validate_string($package_name_real)

  validate_string($socker_group)

  yumrepo { 'docker_yum_repo':
#    ensure   => present,
    name     => 'dockerrepo',
    descr    => 'Docker Repository',
    baseurl  => $repo_url_real,
    enabled  => 'True',
    gpgkey   => $repo_key_real,
    gpgcheck => 'True',
  }

  package { 'docker_package':
    ensure  => installed,
    name    => $package_name_real,
    require => Yumrepo['docker_yum_repo'],
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
