use strict;
use warnings;

use Test::More tests => 7;
use Test::Mojo;

use FindBin '$Bin';
use lib "$Bin/../lib";

use Mojolicious::Lite;
use_ok( 'Mojolicious::Plugin::HashedParams' );

plugin 'HeshedParams';

get '/one' => sub {
  my $self = shift;
  my $prms = $self->hparams();
  $self->render( text => qq~Lim per_m: $prms->{lim}{per_m} per_h: $prms->{lim}{per_h} per_d: $prms->{lim}{per_d}~ );
};

get '/two' => sub {
  my $self = shift;
  my $prms = $self->hparams();
  $self->render( text => qq~[$prms->{message}{task}{id}]Msg:$prms->{message}{body}~ );
};

get '/tree' => sub {
  my $self = shift;
  my $prms = $self->hparams( 'message' );
  $self->render( text => qq~$prms->{message}{body} writen by $prms->{message}{author}~ );
};

my $t = Test::Mojo->new;
$t->get_ok( '/one?lim[per_m]=5&lim[per_h]=30&lim[per_d]=100' )->content_is( 'Lim per_m: 5 per_h: 30 per_d: 100' );
$t->get_ok( '/two?message[body]=BlaBlaBla&message[task][id]=32' )->content_is( '[32]Msg:BlaBlaBla' );
$t->get_ok( '/tree?message[body]=USAStopWars&message[author]=Perl&post[id]=31337&post[name]=StopWar' )
    ->content_is( 'USAStopWars writen by Perl' );
