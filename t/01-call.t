#!/usr/bin/perl -w

use Test::More tests => 2;

BEGIN { use_ok('Sys::Blkid'); }


# Constants defined?

ok( sub { BLKID_DEV_FIND == 0 } , "BLKID_DEV_FIND set correctly. The others will work as well.");

# blkid_devno_to_devname
my $dev = $ARGV[0];
print(STDERR "Testing dev " . $dev . "\n");
print(STDERR "Devname of device $dev: " . Sys::Blkid::blkid_devno_to_devname($dev) . "\n");


1;
