# == Class: docker::conf:slice
#
# Configure systemd resource slice for docker
#
class docker::conf::slice (
  $systemd_slice = undef,
) {
  if $systemd_slice != undef {
    validate_string($systemd_slice)

    file { 'docker_slice_conf':
      ensure  => present,
      path    => '/etc/systemd/system/docker.service.d/slice.conf',
      content => template('docker/slice.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['etc_docker_service_d_dir'],
      notify  => Exec['systemd_reload'],
    }
    if $docker::manage_containerd_real {
      file { 'containerd_slice_conf':
        ensure  => present,
        path    => '/etc/systemd/system/containerd.service.d/slice.conf',
        content => template('docker/slice.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['etc_containerd_service_d_dir'],
        notify  => Exec['systemd_reload'],
      }
    }
  }
}
