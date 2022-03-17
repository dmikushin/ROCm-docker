#!/usr/bin/perl -w

# We expect the id to be provided via ID environment variable:
# docker run --env ID=\"$(id)\" ...
#
# in the following format:
# uid=1001(dmikushin) gid=1001(dmikushin) groups=1001(dmikushin),27(sudo),44(video),109(render),998(docker)
#

my($id) = $ENV{'ID'};

print "Starting Docker container for \"$id\"\n";

if ($id !~ m/uid\=(?<UID>\w+)\((?<UID_USER>[a-zA-Z0-9_]+)\)\s+gid\=(?<GID>\w+)\((?<GID_USER>[a-zA-Z0-9_]+)\)\s+groups\=(?<GROUPS>(\d+\([a-zA-Z0-9_]+\)\,?)+)/)
{
	die("Malformed \$(id) argument \"$id\"");
}

if (!defined($+{UID}))
{
	die("Unable to capture UID from \$(id) argument \"$id\"");
}
my($uid) = $+{UID};

if (!defined($+{UID_USER}))
{
	die("Unable to capture UID_USER from \$(id) argument \"$id\"");
}
my($uid_user) = $+{UID_USER};

if (!defined($+{GID}))
{
	die("Unable to capture GID from \$(id) argument \"$id\"");
}
my($gid) = $+{GID};

if (!defined($+{GID_USER}))
{
	die("Unable to capture GID_USER from \$(id) argument \"$id\"");
}
my($gid_user) = $+{GID_USER};

if (!defined($+{GROUPS}))
{
	die("Unable to capture GROUPS from \$(id) argument \"$id\"");
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
	system("useradd --create-home --gid $gid --uid $uid -G $groups_csv --shell /bin/bash $uid_user");
}

system("sudo -i -u $uid_user");

