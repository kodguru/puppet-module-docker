# == Class: docker::image
#
#
define docker::image (
  $ensure = 'present',
  $image  = $name,
  $tag    = 'latest',
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "docker::image::${name}::ensure is invalid and does not match the regex.")

  validate_string($image)
  validate_string($tag)

  $image_real = "${image}:${tag}"
  $image_cond = "images=`docker images | grep \"${image}\" | awk 'BEGIN{ OFS=\":\" } { print \$1, \$2 }'` && exist='false' && for img in \${images} ; do if [ \${img} == \"${image_real}\" ]; then exist='true' ; fi ; done && test \${exist} == 'true'"

  if $ensure == 'present' {
    exec { "docker_image_${name}_pull":
      provider => 'shell',
      path     => [ '/usr/sbin', '/usr/bin', '/bin' ],
      command  => "docker pull ${image_real}",
      unless   => $image_cond,
    }
  }
}
