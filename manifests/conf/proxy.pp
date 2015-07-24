# == Class: docker::conf:proxy
#
# Configure proxy for docker
#
class docker::conf::proxy (
  $ensure     = undef,
  $url        = undef,
  $port       = undef,
  $exceptions = undef,
) {

  validate_re($ensure, [ '^present$', '^env$', '^absent$' ],
    "docker::conf::proxy::ensure is invalid and does not match the regex.")

  if $ensure == 'present' or $ensure == 'env' {
    if $ensure == 'env' {
      $proxy_url_real        = hiera('env::proxy::url')
      $proxy_port_real       = hiera('env::proxy::port')
      $proxy_exceptions_real = join(hiera_array('env::proxy::exceptions'), ',')
    } else {
      $proxy_url_real        = $url
      $proxy_port_real       = $port
      $proxy_exceptions_real = join($exceptions, ',')
    }

    validate_string($proxy_url_real)
    validate_port($proxy_port_real)
    validate_string($proxy_exceptions_real)

    file { 'docker_http_proxy_conf':
      ensure  => present,
      path    => '/etc/systemd/system/docker.service.d/http-proxy.conf',
      content => template('docker/http-proxy.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      require => File['etc_docker_service_d_dir'],
      notify  => Exec['systemd_reload'],
    }
  }

  if $ensure == 'absent' {
    file { 'docker_http_proxy_conf_absent':
      ensure => absent,
      path   => '/etc/systemd/system/docker.service.d/http-proxy.conf',
      notify => Exec['systemd_reload'],
    }
  }
}
