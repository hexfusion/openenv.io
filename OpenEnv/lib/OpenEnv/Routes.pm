package OpenEnv::Routes;

=head1 NAME

OpenEnv::Routes - routes for OpenEnv application

=cut

use Dancer2 appname => 'OpenEnv';
use Carp;
use Dancer2::Plugin::Auth::Extensible;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Email;
#use Dancer2::Plugin::Interchange6;
#use Dancer2::Plugin::Interchange6::Routes;
use Dancer2::Plugin::TemplateFlute;
use DateTime;
use HTML::FormatText::WithLinks;
use Try::Tiny;

#use OpenEnv::Routes::Foo;
use Encode qw/encode/;

=head1 ROUTES

See also:

L<OpenEnv::Routes::Foo>,

=head2 get /

Home page

=cut

get '/' => sub {
    my $tokens = {};

    my $form = form('register-email');
    $form->reset;

    $tokens->{title} = "Vienna Austria September 2016";

    # only show 'register now' if we're before 
    $tokens->{show_register_container} = 1;

    my $news = schema('default')->resultset('Message')->search(
        {
            'message_type.name' => 'news_item',
            'me.public'         => 1,
        },
        {
            join     => 'message_type',
            prefetch => 'author',
            order_by => { -desc => 'me.created' },
        }
    );

    my $news_count = $news->count;

    # we want to display at most 2 news items
    my @news = $news->rows(2)->all;

    # but we don't want the second item if it is more than 7 days old
    pop @news
      if ( $news_count > 1
        && $news[1]->created < DateTime->today->subtract( days => 7 ) );

    # and if we have old news we're not displaying then we add a link
    # to news archive
    if ( $news_count > scalar(@news) ) {
        $tokens->{old_news} = 1;
    }

    $tokens->{news} = \@news;

    add_javascript( $tokens, "/js/index.js" );

    var no_title_wrapper => 1;

    template 'index', $tokens;
};

=head1 METHODS

=head2 add_javascript($tokens, @js_urls);

=cut

sub add_javascript {
    my $tokens = shift;
    foreach my $src ( @_ ) {
        push @{ $tokens->{"extra-js"} }, { src => $src };
    }
}

=head2 add_navigation_tokens

Add title and description tokens;

=cut

sub add_navigation_tokens {
    my $tokens = shift;

    my $uri = var('uri') || request->path;
    $uri =~ s{^/+}{};
    my $nav = shop_navigation->find( { uri => $uri } );

    $tokens->{title}       = $nav->name;
    $tokens->{description} = $nav->description;
}

true;
