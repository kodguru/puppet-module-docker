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

- *Default*: 'https://get.docker.com/rpm/1.7.1/centos-7/RPMS/x86_64/docker-engine-1.7.1-1.el7.centos.x86_64.rpm'

socket_group
------------

- *Default*: 'docker'

manage_group_users
------------------

- *Default*: 'undef'

images
------

- *Default*: 'undef'

===

# define docker::conf::user

ensure
------

- *Default*: 'present'

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
