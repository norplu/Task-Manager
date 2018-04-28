use strict;
use warnings;

use TaskManager;

my $app = TaskManager->apply_default_middlewares(TaskManager->psgi_app);
$app;

