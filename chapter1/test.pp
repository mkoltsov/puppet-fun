file { 
    '/etc/modules': 
        content => "# Managed by Puppet!\n\ndrbd\n", 
}

package { 
    'haproxy': 
        provider => 'dpkg', 
        source   => '/opt/packages/haproxy-1.5.1_amd64.dpkg', 
}

service { 
    'count-logins': 
        provider  => 'base', 
        ensure    => 'running', 
        binary    => '/usr/local/bin/cnt-logins', 
        start     => '/usr/local/bin/cnt-logins --daemonize', 
        subscribe => File['/usr/local/bin/cnt-logins'], 
}

group { 
    'proxy-admins': 
        ensure => present, 
        gid    => 4002, 
}
user { 
    'john': 
        uid        => 2014, 
        home       => '/home/john' 
        managehome => true, # <- adds -m to useradd 
        gid        => 1000, 
        shell      => '/bin/zsh', 
        groups     => [ 'proxy-admins' ], 
}

exec { 
    'tar cjf /opt/packages/homebrewn-3.2.tar.bz2': 
        cwd     => '/opt', 
        path    => '/bin:/usr/bin', 
        creates => '/opt/homebrewn-3.2', 
}

exec { 
    'perl -MCPAN -e "install YAML"': 
        path   => '/bin:/usr/bin', 
        unless => 'cpan -l | grep -qP ^YAML\\b' 
}

exec { 
    'apt-get update': 
        path        => '/bin:/usr/bin', 
        subscribe   => 
            File['/etc/apt/sources.list.d/jenkins.list'], 
        refreshonly => true, 
}

cron { 
    'clean-files': 
        ensure      => present, 
        user        => 'root', 
        command     => '/usr/local/bin/clean-files', 
        minute      => '1', 
        hour        => '3', 
        weekday     => [ '2', '6' ], 
        environment => 'MAILTO=felix@example.net', 
}

mount { 
    '/media/gluster-data': 
        ensure  => 'mounted', 
        device  => 'gluster01:/data', 
        fstype  => 'glusterfs', 
        options => 'defaults,_netdev', 
        dump    => 0, 
        pass    => 0, 
}