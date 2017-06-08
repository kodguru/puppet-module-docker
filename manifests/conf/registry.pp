# == Class: docker::conf::registry
#
# Configure registry credentials
#
class docker::conf::registry (
  $ensure = 'present',
  $host   = 'MANDATORY',
  $token  = 'MANDATORY',
  $email  = undef,
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    'docker::conf::registry::ensure is invalid and does not match the regex.')

  if $host == 'MANDATORY' or empty($host) {
    fail('docker::conf::registry::host is MANDATORY.')
  }
  validate_fqdn($host)

  if $token == 'MANDATORY' or empty($token) {
    fail('docker::conf::registry::token is MANDATORY.')
  }
  validate_re($token, '^[A-Za-z0-9=]*$',
    'docker::conf::registry::token is invalid and does not match the regex.')

  if $email != undef or $email != '' {
    validate_email($email)
  }

  file { 'root_dockercfg':
    ensure  => present,
    path    => '/root/.dockercfg',
    content => template('docker/dockercfg.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
