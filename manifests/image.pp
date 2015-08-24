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
    $image_cond = "images=`docker images | grep ${image} | awk '{ print \$2 }'` && exist='false' && for image in \${images} ; do if [ \${image} == \"\${tag}\" ] ; then exist='true' ; fi ; done && test \${exist} == 'true'"
  } else {
    $image_real = $image
    $image_cond = "docker images | awk '{ print \$1 }' | grep ${image}"
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
