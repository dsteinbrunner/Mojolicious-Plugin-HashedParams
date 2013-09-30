use strict;
use warnings;

use Test::More tests => 9;
use Test::Mojo;

use FindBin '$Bin';
use lib "$Bin/../lib";

use Mojolicious::Lite;
use_ok( 'Mojolicious::Plugin::HashedParams' );

plugin 'HashedParams';

get '/one' => sub {
  my $self = shift;
  my $prms = $self->hparams();
  $self->render( text => qq~$prms->{lim}{per_m}/$prms->{lim}{per_h}/$prms->{lim}{per_d}~ );
};

get '/two' => sub {
  my $self = shift;
  my $prms = $self->hparams();
  $self->render( text => qq~[$prms->{message}{task}{id}]Msg:$prms->{message}{body}~ );
};

get '/tree' => sub {
  my $self = shift;
  my $prms = $self->hparams( 'message' );
  $self->render( text => qq~$prms->{message}{body} by $prms->{message}{author}~ );
};

get '/four' => sub {
  my $self = shift;
  my $prms = $self->hparams();
  $self->render( text => qq~$prms->{message}{title}~ );
};

my $t = Test::Mojo->new;
$t->get_ok( '/one?lim[per_m]=5&lim[per_h]=30&lim[per_d]=100' )                ->content_is( '5/30/100' );
$t->get_ok( '/two?message[body]=Test&message[task][id]=32' )                  ->content_is( '[32]Msg:Test' );
$t->get_ok( '/tree?message[body]=Test&message[author]=Perl&post[id]=31337' )  ->content_is( 'Test by Perl' );
$t->get_ok( '/four?mess\'age[t`i^tle{{[][---[[--[-[-[-[-[-]]]]]]]]"]=Test' )  ->content_is( 'Test' );
