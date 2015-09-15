# == Class: docker::registry::artifactory
#
# Configure Artifactory
#
define docker::registry::artifactory (
  $ensure = 'present',
  $host   = undef,
  $email  = undef,
  $token  = undef,
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "docker::registry::artifactory::${name}::ensure is invalid and does not match the regex.")
  validate_string($host)
  validate_email($email)
  validate_string($token)

  exec { 'root_dockercfg':
    command => 
    unless  => ,
  }
}
