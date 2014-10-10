#!/usr/bin/perl

use strict;

use Fcntl;
use NDBM_File;

use ObjectManager::ObjectManager;

my @MODULES = 
(
	\&ObjectManager::add,
	\&ObjectManager::edit,
	\&ObjectManager::remove,
	\&ObjectManager::list,
	\&ObjectManager::save,
	\&ObjectManager::load,
	\&ObjectManager::exit
);

my @NAMES = 
(
	"Add object",
	"Edit object",
	"Remove object",
	"List of objects",
	"Save to file",
	"Load from file",
	"Exit",
);

ObjectManager::fill();
ObjectManager::list();

sub menu
{
	my $i = 0;
	print "\n------------------------------\n";
	print "Menu:\n";
	foreach my $s(@NAMES)
	{
		$i++;
		print "$i. $s\n";
	}
	print "------------------------------\n";
	print "Enter your number:\n";
	my $ch = <STDIN>;
	return ($ch-1);
}

while(1)
{
	my $ch = menu();
	if(defined $MODULES[$ch])
	{
		print $NAMES[$ch]." launching...\n\n";
		$MODULES[$ch]->();
	}
	else
	{
		exit();
	}
}
