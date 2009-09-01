#!/usr/bin/perl -w

use Test::More tests => 2;

BEGIN { use_ok('Sys::Blkid', ':funcs'); }


# Constants defined?

is(BLKID_DEV_FIND, 0, 'BLKID_DEV_FIND set correctly.');

# blkid_devno_to_devname
is (blkid_devno_to_devname(2049), '/dev/sda1' , 'Device 2049 is /dev/sda1');
is (blkid_devno_to_devname(8, 1), '/dev/sda1' , 'Device 8, 1 is /dev/sda1');
is (blkid_devno_to_devname(1), undef, 'Device 1 is undef');

#print(Sys::Blkid::_blkid_devno_to_devname('asdf'));