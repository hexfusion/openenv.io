=head1 OpenEnv::Schema

Inherit from L<Interchange6::Schema> and set to result_namespace to 

L<Interchange6::Schema::Result> plus L<OpenEnv::Schema::Result>.

=cut

package OpenEnv::Schema;

use base 'Interchange6::Schema';

__PACKAGE__->load_components( 'Schema::Config' );

Interchange6::Schema->load_namespaces(
    default_resultset_class => 'ResultSet',
    result_namespace        => [ 'Result', '+OpenEnv::Schema::Result' ],
    resultset_namespace     => [ 'ResultSet', '+OpenEnv::Schema::ResultSet' ],
);

1;
