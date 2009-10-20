# $Id: Blkid.pm,v 1.8 2009/10/20 21:06:03 bastian Exp $
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
			blkid_probe_all_new
			blkid_get_dev
			blkid_get_dev_size
			blkid_verify
			blkid_get_tag_value
			blkid_get_devname
			blkid_dev_iterate_begin
			blkid_dev_set_search
			blkid_dev_next
			blkid_dev_iterate_end

			blkid_tag_iterate_begin
			blkid_tag_next
			blkid_tag_iterate_end

			blkid_dev_has_tag
			blkid_find_dev_with_tag
			blkid_parse_tag_string
			blkid_parse_version_string
			blkid_get_library_version
			blkid_encode_string
			blkid_safe_string
			blkid_send_uevent
			blkid_evaluate_tag
			blkid_known_fstype

			blkid_new_probe
			blkid_free_probe
			blkid_reset_probe

			blkid_probe_set_device
			blkid_probe_set_request
			blkid_probe_filter_usage
			blkid_probe_filter_types

			blkid_probe_invert_filter
			blkid_probe_reset_filter
			blkid_do_probe
			blkid_do_safeprobe
			blkid_probe_numof_values
			blkid_probe_get_value
			blkid_probe_lookup_value
			blkid_probe_has_value
		)],
);
Exporter::export_ok_tags('consts');
Exporter::export_ok_tags('funcs');

our $VERSION = "0.6";

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



package Device::Blkid::Device;

sub toHash {
	my ($self) = @_;

	my $ret = {};

	my $iter = Device::Blkid::blkid_tag_iterate_begin($self);
	return undef if (!$iter);

	while (my $h = Device::Blkid::blkid_tag_next($iter)) {
		$ret->{$h->{type}} = $h->{value};
	}

	Device::Blkid::blkid_tag_iterate_end($iter);

	return $ret;
}

1;
