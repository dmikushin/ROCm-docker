#!/usr/bin/perl -w
my($url) = $ARGV[0];
my($baseurl) = $url;
$baseurl =~ s/\#.*//g;

my($output) = join("", `curl -sL $baseurl`);
my(@versions) = ();
while (1)
{
	$output =~ s/(\d+\.\d+(\.\d+)?)//;
	if (defined($1))
	{
		push(@versions, $1);
		next;
	}
	last;
}

my %temp_hash = map { $_ => 1 } @versions;
my @unique_versions = keys %temp_hash;

@versions = sort(@unique_versions);
if (scalar(@versions) == 0)
{
	die("No versions avaialable");
}

$url =~ s/\#/$versions[-1]/g;
print($url);
