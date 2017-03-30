node 'agent' {
    $packages = [ 'apache2', 
        'libapache2-mod-php5', 
        'libapache2-mod-passenger', ] 
    package {
        $packages:
            ensure => 'installed',
    }
    ->
    service {
        'apache2':
            ensure => 'running',
            enable => true,
    }
}

puppet master --configprint manifest
puppet master --configprint all | less