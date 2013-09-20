package Mojolicious::Plugin::HashedParams;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.03';

sub register {
  my ( $plugin, $app ) = @_;

  $app->helper(
    hparams => sub {
      my ( $self, @permit ) = @_;

      if ( !$self->stash( 'hparams' ) ) {
        my $hprms = $self->req->params->to_hash;
        my $index = 0;
        my @array;

        foreach my $p ( keys %$hprms ) {
          my @list;

          foreach my $n ( split /[\[\]]/, $p ) {
            push @list, $n if length( $n ) > 0;
          }

          map $array[$index] .= "{$list[$_]}", 0 .. $#list;

          $array[$index] .= " = '$hprms->{$p}';";
          $index++;
        }

        my $code = 'my $h = {};';
        map { $code .= "\$h->$_" } @array;
        $code .= '$h;';

        my $ret = eval $code;
        warn @$ if $@;

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

Mojolicious::Plugin::HashedParams - Transformation request parameters into a hash and multi-hash

=head1 SYNOPSIS

  plugin 'HashedParams';

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
