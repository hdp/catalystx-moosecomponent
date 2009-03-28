package CatalystX::MooseComponent;
# ABSTRACT: Ensure your Catalyst component isa Moose::Object

use strict;
use warnings;
use Moose ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods;

sub init_meta {
  shift;
  my %p = @_;

  my $meta = Moose->init_meta(%p);

  if ($Catalyst::VERSION < 5.8 && ! $p{for_class}->isa('Moose::Object')) {
    $meta->superclasses('Moose::Object', $meta->superclasses);
    $meta->add_around_method_modifier(new => sub {
      my $next = shift;
      my ($self, $app) = @_;
      my $arguments = ( ref( $_[-1] ) eq 'HASH' ) ? $_[-1] : {};
      return $self->$next( $self->merge_config_hashes($self->config, $arguments) );
    });
  }

  return $meta;
}

1;

=head1 SYNOPSIS

  package MyApp::Controller::Foo;

  use Moose;
  BEGIN { extends 'Catalyst::Controller' }
  use CatalystX::MooseComponent;

  # My::CatalystComponent now isa Moose::Object

=head1 DESCRIPTION

This module lets you write Catalyst components that are Moose objects without
worrying about whether Catalyst::Component is Moose-based or not (Catalyst 5.7
vs. 5.8).  It handles pulling in global application configuration and adding
C<Moose::Object> to your component's superclasses.

=method init_meta

Called automatically by C<import> to set up the proper superclasses and wrap
C<new()>.

=cut
