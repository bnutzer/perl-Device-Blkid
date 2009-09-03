# $Id: Blkid.pm,v 1.4 2009/09/03 14:55:05 bastian Exp $
# Copyright (c) 2007 Collax GmbH
package Device::Blkid;

use 5.006001;
use strict;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

our %EXPORT_TAGS = (
	consts	=> [qw(
			BLKID_DEV_FIND
			BLKID_DEV_CREATE
			BLKID_DEV_VERIFY
			BLKID_DEV_NORMAL

			BLKID_PROBREQ_LABEL
			BLKID_PROBREQ_LABELRAW
			BLKID_PROBREQ_UUID
			BLKID_PROBREQ_UUIDRAW
			BLKID_PROBREQ_TYPE
			BLKID_PROBREQ_SECTYPE
			BLKID_PROBREQ_USAGE
			BLKID_PROBREQ_VERSION

			BLKID_USAGE_FILESYSTEM
			BLKID_USAGE_RAID
			BLKID_USAGE_CRYPTO
			BLKID_USAGE_OTHER

			BLKID_FLTR_NOTIN
			BLKID_FLTR_ONLYIN
		)],
	funcs	=> [qw(
			blkid_put_cache
			blkid_get_cache
			blkid_gc_cache
			blkid_devno_to_devname
			blkid_dev_devname
			blkid_probe_all
			blkid_get_dev
			blkid_get_tag_value
		)],
);
Exporter::export_ok_tags('consts');
Exporter::export_ok_tags('funcs');

our $VERSION = "1.0";

=head1 NAME

Device::Blkid - Interface to libblkid

=head1 VERSION

Version 1.0

=cut

bootstrap Device::Blkid;

=head1 SYNOPSIS

 use Device::Blkid;

=cut


use constant BLKID_DEV_FIND	=> 0x0000;
use constant BLKID_DEV_CREATE	=> 0x0001;
use constant BLKID_DEV_VERIFY	=> 0x0002;
use constant BLKID_DEV_NORMAL	=> (BLKID_DEV_CREATE | BLKID_DEV_VERIFY);

use constant BLKID_PROBREQ_LABEL	=> (1 << 1);
use constant BLKID_PROBREQ_LABELRAW	=> (1 << 2);
use constant BLKID_PROBREQ_UUID		=> (1 << 3);
use constant BLKID_PROBREQ_UUIDRAW	=> (1 << 4);
use constant BLKID_PROBREQ_TYPE		=> (1 << 5);
use constant BLKID_PROBREQ_SECTYPE	=> (1 << 6);
use constant BLKID_PROBREQ_USAGE	=> (1 << 7);
use constant BLKID_PROBREQ_VERSION	=> (1 << 8);

use constant BLKID_USAGE_FILESYSTEM	=> (1 << 1);
use constant BLKID_USAGE_RAID		=> (1 << 2);
use constant BLKID_USAGE_CRYPTO		=> (1 << 3);
use constant BLKID_USAGE_OTHER		=> (1 << 4);

use constant BLKID_FLTR_NOTIN		=> 1;
use constant BLKID_FLTR_ONLYIN		=> 2;



sub blkid_get_cache {
	my ($arg, @rest) = @_;
	if (scalar(@rest)) {
		die('Usage: Device::Blkid::blkid_get_cache(filename)');
	}
	if ($arg eq '') { $arg = undef; }
	return _blkid_get_cache($arg);
}

=head2 Function blkid_devno_to_devname(major, minor)

Return device name for device with given major/minor number combination.

 my $name = blkid_devno_to_devname(8, 1); # Is "/dev/sda"
 if (!blkid_devno_to_devname(0, 1)) {
 	print("No Device 0, 1 found\n");
 }

=head2 Function blkid_devno_to_devname(devno)

 my $name = blkid_devno_to_devname(2049); # Is "/dev/sda"
 if (!blkid_devno_to_devname(1)) {
 	print("No Device 1 found\n");
 }

=cut

sub blkid_devno_to_devname {
	my ($a1, $a2, @r) = @_;

	if (scalar(@r)) {
		die('Syntax error in blkid_devno_to_devname');
	}

	if (!defined($a1)) {
		die('Syntax error in blkid_devno_to_devname');
	}

	if ($a1 !~ m/^[0-9]*$/) {
		die('Syntax error in blkid_devno_to_devname');
	}

	if (defined($a2)) {
		if ($a2 !~ m/^[0-9]*$/) {
			die('Syntax error in blkid_devno_to_devname');
		}
		$a1 = ($a1 << 8) + $a2;
	}

	return _blkid_devno_to_devname($a1);
}



1;
