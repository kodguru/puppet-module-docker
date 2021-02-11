# == Class: docker
#
# Manage Docker
#
class docker (
  $repo_ensure            = 'present',
  $repo_enabled           = 1,
  $repo_url               = 'USE_DEFAULTS',
  $repo_key               = 'USE_DEFAULTS',
  $repo_gpgcheck          = 1,
  $package_name           = 'USE_DEFAULTS',
  $package_cli_name       = 'USE_DEFAULTS',
  $package_ensure         = 'present',
  $socket_group           = 'docker',
  $manage_cli_package     = false,
  $manage_containerd      = false,
  $manage_group_users     = undef,
  $images                 = undef,
) {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '7', '8': {
          $default_repo_url         = 'https://download.docker.com/linux/centos/$::operatingsystemmajrelease/x86_64/stable'
          $default_repo_key         = 'https://download.docker.com/linux/centos/gpg'
          $default_package_name     = 'docker-ce'
          $default_cli_package_name = 'docker-ce-cli'
        }
        default: {
          fail("Docker supports RedHat like systems with major release of 7 or 8 and you have <${::operatingsystemmajrelease}>.")
        }
      }
    }
    default: {
      fail("Docker is only supported on EL. Your osfamily is <${::osfamily}>.")
    }
  }

  validate_re($repo_ensure, [ '^present$', '^absent$' ],
    'docker::repo_ensure is invalid and does not match the regex.')

  if $repo_enabled != 0 and $repo_enabled != 1 {
    fail('docker::repo_enabled is invalid. Must be either 0 or 1.')
  }
  validate_integer($repo_enabled)

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

  if $repo_gpgcheck != 0 and $repo_gpgcheck != 1 {
    fail('docker::repo_gpgcheck is invalid. Must be either 0 or 1.')
  }
  validate_integer($repo_gpgcheck)

  if $package_name == 'USE_DEFAULTS' {
    $package_name_real     = $default_package_name
    $package_cli_name_real = $default_cli_package_name
  } else {
    $package_name_real     = $package_name
    $package_cli_name_real = $package_cli_name
  }
  validate_string($package_name_real)
  validate_string($package_cli_name_real)

  validate_string($package_ensure)

  validate_string($socket_group)

  if is_string($manage_containerd) {
    $manage_containerd_real = str2bool($manage_containerd)
  } else {
    $manage_containerd_real = $manage_containerd
  }
  validate_bool($manage_containerd_real)

 if is_string($manage_cli_package) {
    $manage_cli_package_real = str2bool($manage_cli_package)
  } else {
    $manage_cli_package_real = $manage_cli_package
  }

  yumrepo { 'docker_yum_repo':
    ensure   => $repo_ensure,
    name     => 'dockerrepo',
    descr    => 'Docker Repository',
    baseurl  => $repo_url_real,
    enabled  => $repo_enabled,
    gpgkey   => $repo_key_real,
    gpgcheck => $repo_gpgcheck,
  }

  package { 'docker_package':
    ensure  => $package_ensure,
    name    => $package_name_real,
    require => Yumrepo['docker_yum_repo'],
  }

  if $manage_cli_package_real {
    package { 'docker_cli_package':
      ensure  => $package_ensure,
      name    => $package_cli_name_real,
      require => Yumrepo['docker_yum_repo'],
    }
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

  if $manage_containerd_real {
    file { 'etc_containerd_service_d_dir':
      ensure => directory,
      path   => '/etc/systemd/system/containerd.service.d',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
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
