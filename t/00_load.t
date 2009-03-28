use strict;
use warnings;
use Test::More tests => 1;

package MyApp;
use Catalyst;

package MyApp::Component;
use Moose;
extends 'Catalyst::Component';
::use_ok 'CatalystX::MooseComponent';
