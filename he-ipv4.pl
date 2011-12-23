#!/usr/bin/perl

use 5.10.1;
use warnings;
use strict;
use Switch;

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
	slog("the IPv4 update script must be executed by root, not " . $curUser . ". exiting", 1)
	exit 1;
}

undef $curUser;

unless (-e $configFile) {
	slog("\"/var/cache/he-ipv4.yml\" doesn't exist. attempting to create file", 3);
	slog("woooo", 3);
	my $yaml = YAML::Tiny->new;
	$yaml->[0]->{ipv4} = '127.0.0.1';
	$yaml->[0]->{url} = '0';
	$yaml->write($configFile);
	if (-e $configFile) {
		slog("file created successfully", 3);
	} else {
		slog("crap, something didn't go as planned. file does not appear to have been created. exiting", 1);
		exit 1;
	}
}

sub slog {
	if ($debug >= 1) {
		my $message = shift;
		my $level = shift;
		switch ($level) {
			case 3 {
				if ($level <= $debug) { info($message); }
			}
			case 2 {
				if ($level <= $debug) { warning($message); }
			}
			case 1 {
				if ($level <= $debug) { error($message); }
			}
			else { warning("incorrect value used for message level on subroutine slog call on line " . __LINE__); }
		}
		if ($debug == 4) { say($message); }
	}
}