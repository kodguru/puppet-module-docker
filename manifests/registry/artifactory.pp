# == Class: docker::registry::artifactory
#
# Configure Artifactory credentials
#
class docker::registry::artifactory (
  $ensure = 'present',
  $host   = 'MANDATORY',
  $token  = 'MANDATORY',
  $email  = undef,
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    'docker::registry::artifactory::ensure is invalid and does not match the regex.')

  if $host == 'MANDATORY' or empty($host) {
    fail('docker::registry::artifactory::host is MANDATORY.')
  }
  validate_fqdn($host)

  if $token == 'MANDATORY' or empty($token) {
    fail('docker::registry::artifactory::token is MANDATORY.')
  }
  validate_re($token, '^[A-Za-z0-9=]*$',
    'docker::registry::artifactory::token is invalid and does not match the regex.')

  if $email != undef or $email != '' {
    validate_email($email)
  }

  file { 'root_dockercfg':
    ensure  => present,
    path    => '/root/.dockercfg',
    content => template('docker/dockercfg_artifactory.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
