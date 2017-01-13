# == Class: docker::conf:daemon
#
# Configure dockerd
#
class docker::conf::daemon (
  $ensure      = 'present',
  $daemon_name = 'USE_DEFAULTS',
  $flags       = undef,
) {

  if versioncmp($::docker_version, '1.12.0') < 0 {
    $default_daemon_name = 'docker daemon'
  } else {
    $default_daemon_name = 'dockerd'
  }

  validate_re($ensure, [ '^present$', '^absent$' ],
    "docker::conf::daemon::ensure is invalid and does not match the regex.")

  if $flags != undef {
    validate_hash($flags)
  }

  if $daemon_name == 'USE_DEFAULTS' {
    $daemon_name_real = $default_daemon_name
  } else {
    $daemon_name_real = $daemon_name
  }
  validate_string($daemon_name_real)

  if $ensure == 'present' {
    file { 'docker_daemon_conf':
      ensure  => present,
      path    => '/etc/systemd/system/docker.service.d/daemon.conf',
      content => template('docker/daemon.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['etc_docker_service_d_dir'],
      notify  => Exec['systemd_reload'],
    }
  }

  if $ensure == 'absent' {
    file { 'docker_daemon_conf_absent':
      ensure => absent,
      path   => '/etc/systemd/system/docker.service.d/daemon.conf',
      notify => Exec['systemd_reload'],
    }
  }
}
