#!/usr/bin/perl -w

# We expect the id to be provided via ID environment variable:
# docker run --env ID=\"$(id)\" ...
#
# in the following format:
# uid=1001(dmikushin) gid=1001(dmikushin) groups=1001(dmikushin),27(sudo),44(video),109(render),998(docker)
#
if (scalar(@ARGV) != 1)
{
	die("Entrypoint must be provided with the \$(id) argument");
}

my($id) = $ARGV[0];

if ($id !~ m/uid=1001(dmikushin) gid=1001(dmikushin) groups=1001(dmikushin),27(sudo),44(video),109(render),998(docker)/)
{
	die("Malformed \$(id) argument \"$id\"");
}

