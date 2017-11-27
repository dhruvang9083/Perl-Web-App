use Mojo::Base 'Mojolicious';
use Mojo::SQLite;

sub startup {
  my $self = shift;

  # Configuration
  $self->plugin('Config');
  $self->secrets($self->config('secrets'));

  # Model
  $self->helper(sqlite => sub { state $sql = Mojo::SQLite->new->from_filename(shift->config('sqlite')) });

  # Migrate to latest version if necessary
  my $path = $self->home->child('migrations', 'app.sql');
  $self->sqlite->auto_migrate(1)->migrations->name('app')->from_file($path);

  # Controller
  my $r = $self->routes;
  $r->get('/' => sub { shift->redirect_to('index') });
}

1;
