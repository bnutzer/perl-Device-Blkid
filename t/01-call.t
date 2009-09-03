#!/usr/bin/perl -w

use Test::More tests => 10;
use Data::Dumper;

BEGIN { use_ok('Device::Blkid', ':funcs', ':consts'); }


my $checkdev = "/dev/sda1";

# Constants defined?

is(BLKID_DEV_FIND, 0, 'BLKID_DEV_FIND set correctly.');

# blkid_devno_to_devname
is (blkid_devno_to_devname(2049), $checkdev , 'Device 2049 is ' . $checkdev);
is (blkid_devno_to_devname(8, 1), $checkdev , 'Device 8, 1 is ' . $checkdev);
is (blkid_devno_to_devname(1), undef, 'Device 1 is undef');

#my $cache = blkid_get_cache('');
my $cache = blkid_get_cache('/dev/blkid.tab');

ok($cache->isa('Device::Blkid::Cache'), 'cache from /dev/blkid.tab is a valid cache');

diag(Dumper($cache));

ok(!defined(blkid_put_cache('Just a text')), "Bogus cache was correctly rejected");
#ok(blkid_put_cache($cache), "Successfully set the cache again");
#
ok(!defined(blkid_gc_cache('Just a text')), "Bogus cache was correctly rejected by blkid_gc_cache");

ok(blkid_gc_cache($cache), "Successfully 'gc' the cache again\n");

is(blkid_probe_all($cache), 0, "probe_all returns successfully");

my $dev = blkid_get_dev($cache, $checkdev, 0);

is(blkid_dev_devname($dev), $checkdev, "blkid_dev_devname returned '$checkdev' again");


printf( "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" .
	"type(checkdev) = %s\n",
	blkid_get_tag_value($cache,
				'TYPE',
				$checkdev
			)
);
