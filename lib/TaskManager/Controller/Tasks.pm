package TaskManager::Controller::Tasks;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

TaskManager::Controller::Tasks - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched TaskManager::Controller::Tasks in Tasks.');
}

=head2 base

Start chain logic for dispatch stuff and yada yada

=cut

sub base :Chained('/') :PathPart('tasks') :CaptureArgs(0) {
    my ($self, $c) = @_;

    # Store result set in stash so it's available for other methods
    $c->stash(resultset => $c->model('DB::Task'));

    $c->log->debug('INSIDE BASE METHOD');
}

=head2 object

Fetch the specified task object based on the id and store it in the stash

=cut

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
    # $id = primary key of task to delete
    my ($self, $c, $id) = @_;

    # Find object and store it in the stash
    $c->stash(object => $c->stash->{resultset}->find($id));

    die "Task $id not found!" if !$c->stash->{object};
}

=head2 list

List all tasks that are available

=cut

sub list :Local {
    my ($self, $c) = @_;

    # Set what is going into the stash data wise
    $c->stash(tasks => [$c->model('DB::Task')->all]);

    $c->stash(template => 'tasks/list.tt2');
}

=head2 list_asc

List all tasks that are available in ascending order

=cut

sub list_asc :Local {
    my ($self, $c) = @_;

    # Set what is going into the stash data wise
    $c->stash(tasks => [$c->model('DB::Task')
                            ->search({}, {order_by => 'progress ASC'})
                        ]);

    # Set what template the stash uses
    $c->stash(template => 'tasks/list.tt2');
}

=head2 form_create_do

Get data from form and send it to the database

=cut

sub form_create_do :Chained('base') :PathPart('form_create_do') :Args(0) {
    my ($self, $c) = @_;

    # This is how you get the values via POST
    my $title = $c->request->params->{title} || "N/A";
    my $description = $c->request->params->{description} || "N/A";
    my $progress = $c->request->params->{progress} || "0";

    # Create the task
    my $task = $c->model('DB::Task')->create({
            title => $title,
            description => $description,
            progress => $progress
        });

    $c->stash(task => $task);

    $c->response->redirect($c->uri_for($self->action_for('list')));
}

=head2 formfu_create

Use formfu to create the thing

=cut

sub formfu_create :Chained('base') :PathPart('formfu_create') :Args(0) :FormConfig {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        my $task = $c->model('DB::Task')->new_result({});

        $form->model->update($task);

        $c->response->redirect($c->uri_for($self->action_for('list')));

        $c->detach;
    }

    $c->stash(template => 'tasks/formfu_create.tt2');
}

=head2 formfu_edit

Use HTML::FormFu to update an existing book

=cut

sub formfu_edit :Chained('object') :PathPart('formfu_edut') Args(0)
    :FormConfig('tasks/formfu_create.yml') {
    my ($self, $c) = @_;

    my $task = $c->stash->{object};
}

=head2 delete

Delete a task

=cut

sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Use object saved by 'object' method and delete it
    $c->stash->{object}->delete;

    $c->stash->{status_msg} = "Task deleted";

    $c->response->redirect($c->uri_for($self->action_for('list')));
}


=encoding utf8

=head1 AUTHOR

Nora Cook,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
