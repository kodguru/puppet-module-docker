# == Class: docker::image
#
#
define docker::image (
  $ensure = 'present',
  $image  = $name,
  $tag    = undef,
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "docker::image::${name}::ensure is invalid and does not match the regex.")

  validate_string($image)
  validate_string($tag)

  if $tag != undef {
    $image_real = "${image}:${tag}"
    $image_cond = "tags=`docker images | awk '/${image}/ && match(\$1, /^${image}$/) { print \$2 }'` && exist='false' && for tag in \${tags} ; do if [ \${tag} == \"${tag}\" ] ; then exist='true' ; fi ; done && test \${exist} == 'true'"
  } else {
    $image_real = $image
    $image_cond = "docker images | awk '/${image}/ && match(\$1, /^${image}$/) { print \$1 }'"
  }

  if $ensure == 'present' {
    exec { "docker_image_${name}_pull":
      provider => 'shell',
      path     => [ '/usr/sbin', '/usr/bin', '/bin' ],
      command  => "docker pull ${image_real}",
      unless   => $image_cond,
    }
  }
}
