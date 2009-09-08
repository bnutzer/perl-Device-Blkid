#!/usr/bin/perl -w

use Test::More tests => 11;
use Data::Dumper;

BEGIN { use_ok('Device::Blkid', ':funcs', ':consts'); }

sub dump_dev {
	my ($dev) = @_;

	my $tagiter = blkid_tag_iterate_begin($dev);
	while (my $t = blkid_tag_next($tagiter)) {
		printf("type: %s - value: %s\n", $t->{type}, $t->{value});
	}
	blkid_tag_iterate_end($tagiter);
}

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

##############################################

if (0) {
	printf( "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" .
		"type(checkdev) = %s\n",
		blkid_get_tag_value($cache,
					undef,
					$checkdev
				)
	);
}


##############################################

if (0) {
	push @_,'asdf';
	printf( "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" .
		"LABEL(/) = %s\n",
		Dumper(blkid_get_devname($cache,
					undef,
					'/foo'
				))
	);
}




##############################################

if (0) {

	my $iter = blkid_dev_iterate_begin($cache);
	my $ret = blkid_dev_set_search($iter, 'TYPE', 'ext3');

	printf("set_search returned %s\n", Dumper($ret));

	while (my $d = blkid_dev_next($iter)) {
		print(Dumper($d));
		my $tagiter = blkid_tag_iterate_begin($d);
		while (my $t = blkid_tag_next($tagiter)) {
			print(Dumper($t));
		}
		blkid_tag_iterate_end($tagiter);
	}

	blkid_dev_iterate_end($iter);
}

##############################################

ok(blkid_dev_has_tag($dev, 'LABEL', '/swap'), 'checkdev is correctly labeld as /swap');
ok(!blkid_dev_has_tag($dev, 'TYPE', 'ext3'), 'checkdev is not ext3, which is correct');
ok(!blkid_dev_has_tag($dev, undef, 'ext3'), 'blkid_dev_has_tag returns false with undef arg (1)');
ok(!blkid_dev_has_tag($dev, 'LABEL', undef), 'blkid_dev_has_tag returns false with undef arg (2)');


##############################################

if (0) {
	$dev = blkid_find_dev_with_tag($cache, 'LABEL', '/swap');
	dump_dev($dev);
}

##############################################

if (0) {
	my $foo = blkid_parse_tag_string('LABEL="foo"');
	print(Dumper($foo));

	$foo = blkid_parse_tag_string('LABEfoo"');
	print(Dumper($foo));
}

##############################################

if (0) {
	$foo = blkid_parse_version_string('8');
	print(Dumper($foo));
}

##############################################

if (0) {
	print(Dumper(blkid_get_library_version()));
}


##############################################

if (0) {
	print(Dumper(blkid_encode_string("foooo+üooooobar-123")));
	print(Dumper(blkid_safe_string("foooo+üooooobar-123")));
}

##############################################

if (0) {
	print(Dumper(blkid_send_uevent('/dev/sda1', 'foo')));
}


##############################################

if (0) {
	print(Dumper(blkid_evaluate_tag('LABEL', '/swap')));
}

##############################################

if (0) {
	print(Dumper(blkid_known_fstype('drbd')));
}

##############################################

if (0) {
	print(Dumper(blkid_new_probe()));
}


##############################################

if (1) {
	my $probe = blkid_new_probe();
	print(Dumper(blkid_probe_filter_types($probe, 0, [ "foo", "bar" ] )));
}
