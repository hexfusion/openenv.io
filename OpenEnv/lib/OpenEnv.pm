package OpenEnv;

=head1 NAME

OpenEnv site

=cut

use Dancer2;
use Dancer2::Plugin::Auth::Extensible;
use Dancer2::Plugin::DBIC;

#use OpenEnv::Routes;

get '/' => sub {
    template 'index';
};

true;
