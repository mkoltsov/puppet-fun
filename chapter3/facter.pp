puppet apply -e 'notify { "I am $fqdn and have $processorcount CPUs": }'

file {
    '/etc/mysql/conf.d/bind-address':
        ensure  => 'file',
        mode    => '644',
        content => "[mysqld]\nbind-address=$ipaddress\n",
}

file {
    '/etc/my-secret':
        ensure => 'file',
        mode   => '600',
        owner  => 'root',
        source =>
            "puppet:///modules/secrets/$clientcert/key",
}

if $operatingsystem != 'Ubuntu' {
    package {
        'avahi-daemon':
            ensure => absent
    }
}

if $osfamily == 'RedHat' {
    $kernel_package = 'kernel'
}

if $operatingsystem == 'Debian' {
    if versioncmp($operatingsystemrelease, '7.0') >= 0 {
        $ssh_ecdsa_support = true
    }
}