# == Class: docker::conf:daemon
#
# Configure dockerd
#
class docker::conf::daemon (
  $ensure = 'present',
  $flags  = undef,
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "docker::conf::daemon::ensure is invalid and does not match the regex.")

  if $flags != undef {
    validate_hash($flags)
  }

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
