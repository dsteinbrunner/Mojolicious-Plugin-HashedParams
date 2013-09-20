use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Mojolicious::Plugin::HashedParams',
    license             => 'perl',
    dist_author         => q{Grishkovelli <grishkovelli@gmail.com>},
    dist_version_from   => 'lib/Mojolicious/Plugin/HashedParams.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Mojolicious' => 4.3,
    },
    add_to_cleanup     => [ 'Mojolicious-Plugin-HashedParams-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
