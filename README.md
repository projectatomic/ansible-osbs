### Prerequisites

RHEL 7 Server, CentOS 7, or Fedora host that has:

* yum repositories configured (using subscription-manager in case of RHEL),
* a hostname that resolves to the host's IP (at least) on the host itself,
* python installed, and
* ssh server running, preferably configured so that you can log in using
  ssh key.

### Usage

You should be able to use the playbook to deploy OSBS suitable for development
(i.e. with authentication disabled) by editing the `hosts` file to include your
hosts.

Simply put your host under the `osv3_masters` section, possibly with [ansible
connection parameters][1] (e.g. `ansible_sudo=true` if you are logging in as
non-root):

    [osv3_masters]
    hostname_or_ip_of_your_host ansible_ssh_user=root

Leave the `auth_proxies` empty for now.

Execute the playbook by running:

    ansible-playbook -i hosts site.yml

If it fails you can get more information by running ansible-playbook with the
`-v` flag.

#### Customization

You can override the default settings in `group_vars/all` for all hosts. See
the file for some examples.

#### Authenticating proxy

The playbook can also install apache httpd and configure it as a reverse proxy
for the OSBS that requires some form of authentication.

To enable the proxy, edit `hosts` and include your host in `auth_proxies`
section. Note that currently the proxy has to be on the same machine as the
openshift instance it is proxying.

You also have to edit `site.yml` and set `behind_auth_proxy` parameter to
`true` so that the OSBS only accepts connection through the proxy.

There are two forms of authentication supported - kerberos and HTTP basic
authentication. Kerberos proxy requires valid keytab in order to work. The
basic authentication is mostly useful for development/debugging when you don't
have a keytab available.

In default configuration starting builds is allowed even for unauthenticated
users. You need to change the `readwrite_groups` (and related) variables in
`group_vars/all` in order to restrict it to authenticated users only. Please
refer to [OpenShift documentation][2] for more information about authorization
policies.

### Usage for atomic-reactor development

If you're working on atomic-reactor and often rebuild the build image,
ansible-osbs can make it a little bit easier.

Edit your `group_vars/all` to contain `atomic_reactor_source: git` and the
`atomic_reactor_git` dictionary to point to the correct base image and your
image's Dockerfile git repository.

Now you can rebuild the atomic-reactor image by pushing your changes to git and
then running:

    ansible-playbook -i hosts atomic_reactor.yml

### Bugs

If the playbook does not work for you, feel free to contact me:

* Martin Milata <mmilata@redhat.com>

[1]: http://docs.ansible.com/intro_inventory.html#list-of-behavioral-inventory-parameters
[2]: https://docs.openshift.org/latest/admin_guide/manage_authorization_policy.html
