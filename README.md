# Puppet Docker module

This module manage Docker.

===

# Comptability

This module has been tested to work on the following systems.

* EL 7

====

# Parameters

## class docker

rpm_url
-------

- *Default*: 'USE_DEFAULTS'

repo_key
--------

- *Default*: 'USE_DEFAULTS'

package_name
------------

- *Default*: 'USE_DEFAULTS'

package_ensure
--------------

- *Default*: 'present'

socket_group
------------

- *Default*: 'docker'

manage_group_users
------------------

- *Default*: 'undef'

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
