# $Id: Blkid.pm,v 1.1 2009/08/31 22:48:04 bastian Exp $
# Copyright (c) 2007 Collax GmbH
package Sys::Blkid;

use 5.006001;
use strict;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);
our @EXPORT = qw ( BLKID_DEV_FIND BLKID_DEV_CREATE BLKID_DEV_VERIFY BLKID_DEV_NORMAL );

our $VERSION = "1.0";

=head1 NAME

Sys::Blkid - Interface to libblkid

=head1 VERSION

Version 1.0

=cut

bootstrap Sys::Blkid;

=head1 SYNOPSIS

 use Sys::Blkid;

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


1;
