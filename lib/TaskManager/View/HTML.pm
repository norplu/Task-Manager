package TaskManager::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    # Use tt2 as the extension instead
    TEMPLATE_EXTENSION => '.tt2',
    render_die => 1,
);

=head1 NAME

TaskManager::View::HTML - TT View for TaskManager

=head1 DESCRIPTION

TT View for TaskManager.

=head1 SEE ALSO

L<TaskManager>

=head1 AUTHOR

Nora Cook,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
