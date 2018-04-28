use strict;
use warnings;
use Test::More;


use Catalyst::Test 'TaskManager';
use TaskManager::Controller::Tasks;

ok( request('/tasks')->is_success, 'Request should succeed' );
done_testing();
