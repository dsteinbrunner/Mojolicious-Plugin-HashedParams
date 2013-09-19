package Mojolicious::Plugin::HeshedParams;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
  my ( $plugin, $app ) = @_;

  $app->helper(
    hparams => sub {
      my ( $self, @permit ) = @_;

      if ( !$self->stash( 'hparams' ) ) {
        my $ret   = {};
        my $hprms = $self->req->params->to_hash;

        foreach my $p ( keys %$hprms ) {
          my @list;

          foreach my $n ( split /[\[\]]/, $p ) {
            push @list, $n if length( $n ) > 0;
          }

          if    ( $#list == 0 ) { $ret->{ $list[0] }                         = $hprms->{$p}; }
          elsif ( $#list == 1 ) { $ret->{ $list[0] }{ $list[1] }             = $hprms->{$p}; }
          elsif ( $#list == 2 ) { $ret->{ $list[0] }{ $list[1] }{ $list[2] } = $hprms->{$p}; }
          else                  { }
        }

        if ( %$ret ) {
          if ( @permit ) {
            foreach my $k ( keys %$ret ) {
              delete $ret->{$k} unless $k ~~ @permit;
            }
          }

          $self->stash( hparams => $ret );
        }
      }
      else {
        $self->stash( hparams => {} );
      }
      return $self->stash( 'hparams' );
    }
  );
}

1;

__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::HeshedParams - Transformation request parameters into a hash and multi-hash

=head1 SYNOPSIS

  plugin 'HeshedParams';

  # Transmit params:
  /route?message[body]=PerlOrDie&message[task][id]=32
    or
  <input type="text" name="message[task][id]" value="32"> 

  get '/route' => sub {
    my $self = shift;
    # you can also use permit parameters
    $self->hparams( qw/message/ );
    # return all parameters in the hash
    $self->hparams();
  };

=head1 AUTHOR

Grishkovelli L<grishkovelli@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2013, Grishkovelli.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
