#!/usr/bin/perl -w

# We expect the id to be provided via ID environment variable:
# docker run --env ID=\"$(id)\" ...
#
# in the following format:
# uid=1001(dmikushin) gid=1001(dmikushin) groups=1001(dmikushin),27(sudo),44(video),109(render),998(docker)
#

my($id) = "" . $ENV{'ID'};

if ($id eq "")
{
	die("The \$(id) environment variable is not defined");
}

print "Starting Docker container for \"$id\"\n";

if ($id !~ m/uid\=(?<UID>\w+)\((?<UID_USER>[a-zA-Z0-9_]+)\)\s+gid\=(?<GID>\w+)\((?<GID_USER>[a-zA-Z0-9_]+)\)\s+groups\=(?<GROUPS>(\d+\([a-zA-Z0-9_]+\)\,?)+)/)
{
	die("Malformed \$(id) environment variable \"$id\"");
}

if (!defined($+{UID}))
{
	die("Unable to capture UID from \$(id) environment variable \"$id\"");
}
my($uid) = $+{UID};

if (!defined($+{UID_USER}))
{
	die("Unable to capture UID_USER from \$(id) environment variable \"$id\"");
}
my($uid_user) = $+{UID_USER};

if (!defined($+{GID}))
{
	die("Unable to capture GID from \$(id) environment variable \"$id\"");
}
my($gid) = $+{GID};

if (!defined($+{GID_USER}))
{
	die("Unable to capture GID_USER from \$(id) environment variable \"$id\"");
}
my($gid_user) = $+{GID_USER};

if (!defined($+{GROUPS}))
{
	die("Unable to capture GROUPS from \$(id) environment variable \"$id\"");
}
my($groups) = $+{GROUPS};

my($groups_csv) = "";
while ($groups =~ s/(?<GROUP_UID>\w+)\((?<GROUP_USER>[a-zA-Z0-9_]+)\)\,?//)
{
	my($group_uid) = $+{GROUP_UID};
	my($group_user) = $+{GROUP_USER};

	# If group exists, delete group
	my($group_exists) = join("", `getent group $group_user`);
	if ($group_exists ne "")
	{
		system("groupmod -g $group_uid $group_user");
	}
	else
	{
		system("groupadd -g $group_uid $group_user");
	}
	$groups_csv .= ",$group_user";
}

$groups_csv =~ s/^\,//g;

if (getpwnam($uid_user))
{
	system("usermod -u $gid -g $uid $uid_user");
}
else
{
	my($create_home) = "--create-home";
	if (-d "/home/$uid_user")
	{
		$create_home = "";
	}
	system("useradd $create_home --gid $gid --uid $uid -G $groups_csv --shell /bin/bash $uid_user");
}

system("bash rocm-compatibility-test.sh");

print "sudo -i -u $uid_user @ARGV\n";

my(@args) = ("sudo", "-i", "-u", "$uid_user", @ARGV);
exec { $args[0] } @args;
#exec("sudo -i -u $uid_user @ARGV");
