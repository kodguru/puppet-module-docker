# Puppet Docker module

This module manage Docker.

===

# Comptability

This module has been tested to work on the following systems.

* EL 7
* EL 8

====

# Parameters

## class docker

rpm_url
-------

- *Default*: 'https://download.docker.com/linux/centos/(7 or 8)/x86_64/stable'

repo_key
--------

- *Default*: 'https://download.docker.com/linux/centos/gpg'

package_name
------------
Name of the docker server package.  Since version 18.09, docker daemon comes in its own package and command line interface package comes separate (see below).

- *Default*: 'docker-ce'

package_cli_name
----------------
Name of the docker client package.  Since version 18.09, docker daemon comes in its own package and command line interface package comes separate (see above).

- *Default*: 'docker-ce-cli'

package_ensure
--------------
Leave at default value to get latest available version.  You can specify a specific version also.

- *Default*: 'present'

socket_group
------------

- *Default*: 'docker'

manage_group_users
------------------

- *Default*: 'undef'

manage_cli_package
------------------
Set this to 'true' if you are installing a version higher than 18.09 and you want the docker-ce-cli version to be the same as the docker-ce version.

- *Default*: false

manage_containerd
-----------------

- *Default*: false

images
------

- *Default*: 'undef'

===

# define docker::image

ensure
------

- *Default*: 'present'

image
-----

- *Default*: $name

tag
---

- *Default*: undef

===

# define docker::conf::user

ensure
------

- *Default*: 'present'

===

# class docker::conf::daemon

ensure
------

- *Default*: 'present'

flags
---

- *Default*: 'undef'

===

# class docker::conf::proxy

ensure
------

- *Default*: 'undef'

url
---

- *Default*: 'undef'

port
----

- *Default*: 'undef'

exceptions
----------

- *Default*: 'undef'

===

# class docker::conf::slice

systemd_slice
-------------

- *Default*: undef
