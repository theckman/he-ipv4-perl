#!/usr/bin/perl

use 5.10.1;
use warnings;
use strict;

use YAML::Tiny;
use HTTP::Request;
use Logger::Syslog;

our $userID = "";
our $userPass = "";
our $tunnelID="";

our $debug=4;

our $tunnelName="he-ipv6";

logger_prefix("he-ipv4:");

our $configFile = "/var/cache/he-ipv4.yml";
our $curUser = getlogin();

if ($curUser ne "root") {
	if ($debug >= 1) { error("the IPv4 update script must be executed by root, not " . $curUser . ". exiting"); }
	if ($debug == 4) { say("the IPv4 update script must be executed by root, not " . $curUser . ". exiting"); }
	exit 1;
}

undef $curUser;

unless (-e $configFile) {
	if ($debug >= 3) { info("\"/var/cache/he-ipv4.yml\" doesn't exist. attempting to create file"); }
	if ($debug == 4) { say("\"/var/cache/he-ipv4.yml\" doesn't exist. attempting to create file"); }
	my $yaml = YAML::Tiny->new;
	$yaml->[0]->{ipv4} = '127.0.0.1';
	$yaml->[0]->{url} = '0';
	$yaml->write($configFile);
	if (-e $configFile) {
		if ($debug >= 3) { info("file created successfully"); }
		if ($debug == 4) { say("file created successfully"); }
	} else {
		if ($debug >= 3) { error("crap, something didn't go as planned. file does not appear to have been created. exiting"); }
		if ($debug == 4) { say("crap, something didn't go as planned. file does not appear to have been created. exiting"); }
		exit 1;
	}
}