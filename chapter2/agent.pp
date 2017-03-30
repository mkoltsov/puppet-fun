puppet agent --test
puppet cert --list
puppet cert --sign agent
puppet agent --test --server=master.example.net

[main]
server=master.example.net

puppet cert --revoke agent
puppet cert clean agent

service {
    'puppet': enable => false
}
cron {
    'puppet-agent-run':
        user    => 'root',
        command => 
         'puppet agent --no-daemonize --onetime --logdest=syslog',
        minute  => fqdn_rand(60),
        hour    => absent,
}

file {
    '/usr/local/etc/my_app.ini':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        source =>
            'puppet:///modules/my_app/usr/local/etc/my_app.ini',
}