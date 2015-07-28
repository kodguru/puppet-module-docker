# == Define: docker::conf::user
#
# Define to manage docker group users
#
define docker::conf::user (
  $ensure = 'present',
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "docker::manage_group_user::${name}::ensure is invalid and does not match the regex.")
  validate_string($name)

  if $ensure == 'present' {
    exec { "docker-manage-group-user-${name}":
      path    => [ '/usr/sbin', '/usr/bin', '/bin' ],
      command => "usermod -a -G ${docker::socket_group} ${name}",
      unless  => "grep ${docker::socket_group} /etc/group | grep ${name}",
      require => Group['docker_group'],
    }
  }

  if $ensure == 'absent' {
    exec { "docker-manage-group-user-${name}-remove":
      path    => [ '/usr/sbin', '/usr/bin', '/bin' ],
      command => "gpasswd -d ${name} ${docker::socket_group}",
      onlyif  => "grep ${docker::socket_group} /etc/group | grep ${name}",
      require => Group['docker_group'],
    }
  }
}
