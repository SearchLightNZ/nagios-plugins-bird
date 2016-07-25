# Nagios BIRD plugin

This repository contains [Nagios] plugins for monitoring the
[BIRD routing daemon].

The plugins are written in Perl, and depends on `Monitoring::Plugin` (included
in this Debian package). The necessary library `birdctl.pm` is part of the
librarys (which is also included in this Debian package).

## check_bird

This plugin monitors a protocol instance of the BIRD configuration.

    Usage: check_bird -i <instance> [ -m <max_retries> -r <table> -z -s <socket> ]

    Usage with GNU sytle long options:

          check_bird --instance|i <instance>
                    [ --max_retries|m <max_retries>
                      --retry_interval|n <retry_interval in sec>
                      --table|r <table>
                      --zero|z
                      --socket|s <socket> ]

 * BIRD must be running, or CRITICAL is reported.
 * The protocol instance must be up (tested with max_retires attempts with
   retry_interval seconds pause), or CRITICAL is reported.
 * Optionally, routes must be imported, or CRITICAL is reported.
 * Otherwise, report OK and display the number of routes imported.

The plugin looks for routes in the default table (called `master`), or in the
table specified with option `-r`. If the option `-z` is specified, the plugin
will also report CRITICAL if no routes were found.

If the BIRD control socket is not in the default location `/var/run/bird/bird.ctl`,
then an alternate location can be specified with option `-s`.

Option `--instance|i` is required, and specifies the protocol name to look for.

The plugins tries the fetch the instance `-m` max_retires times before sending
a not available.

 [Nagios]: http://www.nagios.org/
 [BIRD routing daemon]: http://bird.network.cz/

## birdctl.pm

This is a simple Perl module for talking to BIRD's control socket. Briefly,
you may use it as follows:

    use birdctl;
    my $bird = new birdctl(
      socket => $socket_path,
      restrict => 1,
    );
    my $final_result_line = $bird->cmd("show route count");
    my @result_lines = $bird->long_cmd("show route protocol kernel");

The return values of `cmd` and `long_cmd` are the lines verbatim as received
from BIRD, including status codes.

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)
