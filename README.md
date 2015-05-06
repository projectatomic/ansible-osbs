### Prerequisites

RHEL 7, CentOS 7, or Fedora host that has:

* yum repostiories configured (using subscription-manager in case of RHEL),
* a hostname that resolves to the host's IP (at least) on the host itself,
* python installed, and
* ssh server running, preferrably configured so that you can log in using
  ssh key.

### Usage

You should be able to use the plabook to deploy OSBS suitable for development
(i.e. with authentication disabled) by editing the `hosts` file to include your
hosts.

Simply put your host under the `osv3_masters` section, possibly with [ansible
connection parameters][1] (e.g. `ansible_sudo=true` if you are logging in as
non-root):

    [osv3_masters]
    hostname_or_ip_of_your_host ansible_ssh_user=root

Leave the `krb_proxies` empty for now.

Execute the playbook by running:

    ansible-playbook -i hosts site.yml

If it fails you can get more information by running ansible-playbook with the
`-v` flag.

#### Customization

You can override the default settings in `group_vars/all` for all hosts. See
the file for some examples.

#### Kerberos proxy

The playbook can also install apache httpd and configure it as a reverse proxy
for the OSBS that requires valid kerberos ticket. You need to have a kerberos
keytab in order for this to work.

To enable the kerberos proxy, edit `hosts` and include your host in
`krb_proxies` section. Note that currently the proxy has to be on the same
machine as the openshift instance it is proxying.

You also have to edit `site.yml` and set `behind_auth_proxy` parameter to
`true` so that the OSBS only accepts connection through the proxy.

### Bugs

If the playbook does not work for you, feel free to contact me:

* Martin Milata <mmilata@redhat.com>

[1]: http://docs.ansible.com/intro_inventory.html#list-of-behavioral-inventory-parameters
