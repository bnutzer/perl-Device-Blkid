# $Id: Blkid.pm,v 1.9 2009/10/21 16:21:56 bastian Exp $
# Copyright (c) 2007 Collax GmbH
package Device::Blkid;

=head1 NAME

Device::Blkid - Interface to libblkid

=head1 VERSION

Version 0.9

=cut

our $VERSION = "0.9";

=head1 SYNOPSIS

C<Device::Blkid> closely resembles the native interface of libblkid. All
functions provided by libblkid are available from Perl as well. Most
functions work exactly the same way, although a few have been slightly
modified to behave a little more "Perlish".

The most common way of using libblkid will be requesting a device (name)
referring to a device with a given attribute (e.g., "return device name
for LABEL=foo"), or you want all tags of a certain device.

In most cases, it is sensible to use the blkid cache; "undef" will work
in most cases.

 use Device::Blkid qw(:funcs);

 my $cache = blkid_get_cache();

 # Request (first) device with given attribute
 my $devname = blkid_get_devname($cache, 'LABEL', 'foo');
 print("Device $devname has label foo\n");

 # Request attributes of given device
 my $label = blkid_get_tag_value($cache, 'LABEL', '/dev/sda1');

 # Request all attributes of a given device
 use Data::Dumper;
 my $device = blkid_get_dev($cache, '/dev/sda1', 0);
 print("Dump of device attributes: " . Dumper($device));

Most devices contain a label, a UUID, and a type.

=head1 EXPORT

No functions or variables are exported per default. All functions and
constants listed below can be imported explicitly, though.

An export tag C<:funcs> exports all functionsprovided by this module;
C<:consts> exports all known constants.

=cut

use 5.006001;
use warnings;
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

=head1 CONSTANTS

This module provides a number of constants that are also contained in the
blkid.h header:

=over

=item

BLKID_DEV_

=over

=item

BLKID_DEV_FIND

=item

BLKID_DEV_CREATE

=item 

BLKID_DEV_VERIFY

=item

BLKID_DEV_NORMAL

=back

=item

BLKID_PROBREQ_

=over

=item

BLKID_PROBREQ_LABEL

=item

BLKID_PROBREQ_LABELRAW

=item

BLKID_PROBREQ_UUID

=item

BLKID_PROBREQ_UUIDRAW

=item

BLKID_PROBREQ_TYPE

=item

BLKID_PROBREQ_SECTYPE

=item

BLKID_PROBREQ_USAGE

=item

BLKID_PROBREQ_VERSION

=back

=item

BLKID_USAGE_

=over

=item

BLKID_USAGE_FILESYSTEM

=item

BLKID_USAGE_RAID

=item

BLKID_USAGE_CRYPTO

=item

BLKID_USAGE_OTHER

=back

=item

BLKID_FLTR_

=over

=item

BLKID_FLTR_NOTIN

=item

BLKID_FLTR_ONLYIN

=back

You may either access these constants in a fully qualified way
(e.g., C<Device::Blkid::BLKID_DEV_FIND>), by importing single constants,
or by importing the C<:consts> token. See L</EXPORT> section.

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


=head1 FUNCTIONS

The original libblkid functions are not split into categories; they are,
however, listed per source file. This sequence is resembled here.

=head2 cache.c

=head3 Function C<blkid_put_cache($cache)>

Writes the cache object referenced by C<$cache> back to disk. C<$cache> is
invalidated by this call and B<MUST NOT> be used afterwards.

Returns a true value on success, undef on failure.

=head3 Function C<blkid_get_cache($filename)>

Reads the cache from given file, or from the default cache file if $filename
is not defined.

Returns a C<Device::Blkid::Cache> object (which is only usable as argument
to other functions) on success, undef on failure.

=head3 Function C<blkid_gc_cache($cache)>

Runs a garbage collection on given cache object.

Returns a true value on success, undef on failure (cache invalid).


=head2 dev.c

The following functions provide iterations over multiple devices: either all,
or a subset filtered by a search. Get an iterator with
L</blkid_dev_iterate_begin>, optionally set a search filter with
L</blkid_dev_set_search>, fetch the next object with
L</blkid_dev_next>, and finally destroy the iterator with
L</blkid_dev_iterate_end>.

While you are encouraged to call L</blkid_dev_iterate_end>, the class
C<Device::Blkid::DevIterate> will automaticall destroy the associated
iterator when it is removed from memory (i.e., when it is no longer
referenced).

=head3 Function C<blkid_dev_devname($dev)>

Returns the device name associated with a C<Device::Blkid::Device> object,
or undef uppon failure.

=head3 Function C<blkid_dev_iterate_begin($cache)>

Returns an iterator of type C<Device::Blkid::DevIterate> to iterate over
multiple devices (or undef uppon failure).

A cache object is mandatory for this function.

=head3 Function C<blkid_dev_set_search($iter, $search_type, $search_value)>

Restricts objects returned by iterators to given search; e.g., filter for
ext3 file systems with this:

 blkid_dev_set_search($iter, 'TYPE', 'ext3');

=head3 Function C<blkid_dev_next($iterate)>

Returns the next device (as a C<Device::Blkid::Device> object) in this
iteration, or undef, when the end of the list is reached (or another
problem was encountered).

=head3 Function C<blkid_dev_iterate_end($iterate)>

Returns the $iterate object. Does not need to be called (auto-destroyed by
perl).

=head2 devno.c

=head3 Function C<blkid_devno_to_devname(major, minor|devno)>

Returns a device name for any given device number. If passed two arguments, the
device number (devno) will be C<major << 8 + minor>.

 printf("Device 8, 1 is %s, device 2049 is %s as well\n",
 	blkid_devno_to_devname(8,1),
	blkid_devno_to_devname(2049));


=head2 devname.c

=head3 Function C<blkid_probe_all($cache)>

Probes all devices in cache. Returns a true value on success, false on failure.

=head3 Function C<blkid_probe_all_new($cache)>

Probes new devices to cache. Returns a true value on success, false on failure.

=head3 Function C<blkid_get_dev($cache, $devname, $flags)>

Returns a C<Device::Blkid::Device> object referring the given device name (or
undef uppon failure).

Flag BLKID_DEV_CREATE may be given in the flags argument to generate a new
cache entry.

=head2 getsize.c

=head3 Function C<blkid_get_dev_size($fd)>

Returns the size of the given device. Please note that the device is passed by
a file descriptor (B<not a Perl file handle!>). See L<POSIX::open> for more
information.

XXXXXXXXXXXXXxxxxxxxxxXXXXXXXXXXXXxxxxXXXXXXXXXXXXXXxxxXXXXXXXXxxxXXxxXXxxXXxxXXXxx
XXXXXXXXXXXXXxxxxxxxxxXXXXXXXXXXXXxxxxXXXXXXXXXXXXXXxxxXXXXXXXXxxxXXxxXXxxXXxxXXXxx
XXXXXXXXXXXXXxxxxxxxxxXXXXXXXXXXXXxxxxXXXXXXXXXXXXXXxxxXXXXXXXXxxxXXxxXXxxXXxxXXXxx
XXXXXXXXXXXXXxxxxxxxxxXXXXXXXXXXXXxxxxXXXXXXXXXXXXXXxxxXXXXXXXXxxxXXxxXXxxXXxxXXXxx

=head3 Function blkid_devno_to_devname(major, minor|devno)

Return device name for device with given major/minor number combination, or device number.

 my $name = blkid_devno_to_devname(8, 1); # Is "/dev/sda"
 if (!blkid_devno_to_devname(0, 1)) {
 	print("No Device 0, 1 found\n");
 }

 $name = blkid_devno_to_devname(2049); # Is "/dev/sda"
 if (!blkid_devno_to_devname(1)) {
 	print("No Device 1 found\n");
 }

=cut

# XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX 

bootstrap Device::Blkid;

=pod



### /* verify.c */
### extern blkid_dev blkid_verify(blkid_cache cache, blkid_dev dev);
# // TODO Untested

SV *
blkid_verify(_cache, _dev)
	SV *_cache
	SV *_dev
	PREINIT:
		blkid_cache cache = sv2cache(_cache, "blkid_verify");
		blkid_dev dev = sv2dev(_dev, "blkid_verify");
		blkid_dev ret;
		SV *_ret;
	PPCODE:
		if (cache && dev) {
			ret = blkid_verify(cache, dev);

			_ret = sv_newmortal();
			sv_setref_pv(_ret, "Device::Blkid::Device", (void *)ret);
			SvREADONLY_on(SvRV(_ret));
			XPUSHs(_ret);
		} else {
			XPUSHs(&PL_sv_undef);
		}
		

### /* read.c */
### 
### /* resolve.c */
### extern char *blkid_get_tag_value(blkid_cache cache, const char *tagname,
### 				       const char *devname);

char *
blkid_get_tag_value(_cache, _tagname, _devname)
	SV *_cache
	SV *_tagname
	SV *_devname
	PREINIT:
		blkid_cache cache = sv2cache(_cache, "blkid_get_tag_value");
		char *tagname = SvOK(_tagname) ? SvPV_nolen(_tagname) : NULL;
		char *devname = SvOK(_devname) ? SvPV_nolen(_devname) : NULL;
		char *ret;
	CODE:
		RETVAL = NULL;
		if (tagname && devname) {
			RETVAL = blkid_get_tag_value(cache, tagname, devname);
		}
	OUTPUT:
		RETVAL

		

### extern char *blkid_get_devname(blkid_cache cache, const char *token,
### 			       const char *value);

char *
blkid_get_devname(_cache, _token, _value)
	SV *_cache
	SV *_token
	SV *_value
	PREINIT:
		blkid_cache cache = sv2cache(_cache, "blkid_get_tag_value");
		char *token = (SvOK(_token) && SvPOK(_token)) ? SvPV_nolen(_token) : NULL;
		char *value = (SvOK(_value) && SvPOK(_value)) ? SvPV_nolen(_value) : NULL;
		char *ret = NULL;
		SV *_ret = NULL;
	CODE:
		RETVAL = NULL;
		if (cache && token && value) {
			RETVAL = blkid_get_devname(cache, token, value);
		}
	OUTPUT:
		RETVAL
		


### 
### /* tag.c */
### extern blkid_tag_iterate blkid_tag_iterate_begin(blkid_dev dev);

SV *
blkid_tag_iterate_begin(_dev)
	SV *_dev
	INIT:
		blkid_dev dev = sv2dev(_dev, "blkid_tag_iterate_begin");
		blkid_tag_iterate tag_iterate = NULL;
		SV *_tag_iterate;
	PPCODE:
		if (dev) {
			tag_iterate = blkid_tag_iterate_begin(dev);
		}

		if (tag_iterate) {
			_tag_iterate = sv_newmortal();
			sv_setref_pv(_tag_iterate, "Device::Blkid::TagIterate", (void *)tag_iterate);
			SvREADONLY_on(SvRV(_tag_iterate));
			XPUSHs(_tag_iterate);
		} else {
			XPUSHs(&PL_sv_undef);
		}


### extern int blkid_tag_next(blkid_tag_iterate iterate,
### 			      const char **type, const char **value);

SV *
blkid_tag_next(_iterate)
	SV *_iterate
	INIT:
		blkid_tag_iterate iterate = sv2tag_iterate(_iterate, "blkid_tag_next");
		const char *type;
		const char *value;

		HV *rh;
	PPCODE:
		if (iterate) {
			blkid_tag_next(iterate, &type, &value);
			if (type && value) {

				rh = (HV *)sv_2mortal((SV *)newHV());

				hv_store(rh, "type", 4, newSVpv(type, 0), 0);
				hv_store(rh, "value", 5, newSVpv(value, 0), 0);

				XPUSHs(sv_2mortal(newRV((SV *) rh)));
			} else {
				XPUSHs(&PL_sv_undef);
			}
		} else {
			XPUSHs(&PL_sv_undef);
		}


### extern void blkid_tag_iterate_end(blkid_tag_iterate iterate);

void
blkid_tag_iterate_end(_iterate)
	SV *_iterate
	INIT:
		blkid_tag_iterate iterate = sv2tag_iterate(_iterate, "blkid_tag_iterate_end");
	CODE:
		if (iterate) {
			blkid_tag_iterate_end(iterate);
		}


### extern int blkid_dev_has_tag(blkid_dev dev, const char *type,
### 			     const char *value);

IV
blkid_dev_has_tag(_dev, type, value)
	SV *_dev
	const char *type
	const char *value
	INIT:
		blkid_dev dev = sv2dev(_dev, "blkid_dev_has_tag");
	CODE:
		/* blkid_dev_has_tag does NOT accept empty value (and "LABEL=foo" type) */
		if (dev && type && value) {
			RETVAL = blkid_dev_has_tag(dev, type, value);
		} else {
			RETVAL = 0;
		}
	OUTPUT:
		RETVAL
	

### extern blkid_dev blkid_find_dev_with_tag(blkid_cache cache,
### 					 const char *type,
### 					 const char *value);

SV *
blkid_find_dev_with_tag(_cache, type, value)
	SV *_cache
	const char *type
	const char *value
	INIT:
		blkid_cache cache = sv2cache(_cache, "blkid_find_dev_with_tag");
		blkid_dev dev = NULL;
		SV *_dev = NULL;
	PPCODE:
		if (cache) {
			dev = blkid_find_dev_with_tag(cache, type, value);
		}

		if (dev) {
			_dev = sv_newmortal();
			sv_setref_pv(_dev, "Device::Blkid::Device", (void *)dev);
			SvREADONLY_on(SvRV(_dev));
			XPUSHs(_dev);
		} else {
			XPUSHs(&PL_sv_undef);
		}


### extern int blkid_parse_tag_string(const char *token, char **ret_type,
### 				  char **ret_val);

SV *
blkid_parse_tag_string(token)
	const char *token
	INIT:
		char *ret_type;
		char *ret_val;

		HV *rh;

		int ret;
	PPCODE:
		if (token) {
			ret = blkid_parse_tag_string(token, &ret_type, &ret_val);
			if (ret == 0 && ret_type && ret_val) {

				rh = (HV *)sv_2mortal((SV *)newHV());

				hv_store(rh, "type", 4, newSVpv(ret_type, 0), 0);
				hv_store(rh, "value", 5, newSVpv(ret_val, 0), 0);

				XPUSHs(sv_2mortal(newRV((SV *) rh)));
			} else {
				XPUSHs(&PL_sv_undef);
			}
		} else {
			XPUSHs(&PL_sv_undef);
		}

### 
### /* version.c */
### extern int blkid_parse_version_string(const char *ver_string);

int
blkid_parse_version_string(ver_string)
	const char *ver_string

### extern int blkid_get_library_version(const char **ver_string,
### 				     const char **date_string);
### 

SV *
blkid_get_library_version()
	INIT:
		const char *ver_string;
		const char *date_string;
		HV *rh;
		int ret;
	PPCODE:
		ret = blkid_get_library_version(&ver_string, &date_string);

		rh = (HV *)sv_2mortal((SV *)newHV());

		hv_store(rh, "int", 3, newSViv(ret), 0);

		if (ver_string && date_string) {


			hv_store(rh, "ver", 3, newSVpv(ver_string, 0), 0);
			hv_store(rh, "date", 4, newSVpv(date_string, 0), 0);

		}

		XPUSHs(sv_2mortal(newRV((SV *) rh)));


### /* encode.c */
### extern int blkid_encode_string(const char *str, char *str_enc, size_t len);
# // TODO: derive string length from input. What does this function do anyways?

SV *
blkid_encode_string(str)
	const char *str
	INIT:
		char str_enc[1024];

		int ret;
	PPCODE:
		ret = blkid_encode_string(str, str_enc, 1023);
		if (ret != 0) {
			XPUSHs(&PL_sv_undef);
		} else {
			XPUSHs(sv_2mortal(newSVpv(str_enc, 0)));
		}


### extern int blkid_safe_string(const char *str, char *str_safe, size_t len);
# // TODO: derive string length from input. What does this function do anyways?

SV *
blkid_safe_string(str)
	const char *str
	INIT:
		char str_safe[1024];

		int ret;
	PPCODE:
		ret = blkid_safe_string(str, str_safe, 1023);
		if (ret != 0) {
			XPUSHs(&PL_sv_undef);
		} else {
			XPUSHs(sv_2mortal(newSVpv(str_safe, 0)));
		}



### /* evaluate.c */
### extern int blkid_send_uevent(const char *devname, const char *action);

int
blkid_send_uevent(devname, action)
	const char *devname
	const char *action
	INIT:
		int ret;
	PPCODE:
		if (devname && action) {
			ret = blkid_send_uevent(devname, action);
			/* Reverse logic -- ret val. 0 is good! */
			if (ret == 0) {
				XPUSHs(sv_2mortal(newSViv(1)));
			} else {
				XPUSHs(&PL_sv_undef);
			}
		} else {
			XPUSHs(&PL_sv_undef);
		}

### extern char *blkid_evaluate_tag(const char *token, const char *value,
### 				blkid_cache *cache);


SV *
blkid_evaluate_tag(token, value)
	const char *token
	const char *value
	INIT:
		char *ret;
	PPCODE:
		if (token && value) {
			ret = blkid_evaluate_tag(token, value, NULL); // Don't use cache. TODO XXX
			XPUSHs(sv_2mortal(newSVpv(ret, 0)));
			free(ret);
		} else {
			XPUSHs(&PL_sv_undef);
		}



### /* probe.c */
### extern int blkid_known_fstype(const char *fstype);

int
blkid_known_fstype(fstype)
	const char *fstype

### extern blkid_probe blkid_new_probe(void);

SV *
blkid_new_probe()
	INIT:
		blkid_probe probe = NULL;
		SV *_probe;
	PPCODE:
		probe = blkid_new_probe();
		if (probe) {
			_probe = sv_newmortal();
			sv_setref_pv(_probe, "Device::Blkid::Probe", (void *)probe);
			SvREADONLY_on(SvRV(_probe));
			XPUSHs(_probe);
		} else {
			XPUSHs(&PL_sv_undef);
		}

### extern void blkid_free_probe(blkid_probe pr);

void
blkid_free_probe(_pr)
	SV *_pr
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_free_probe");
	CODE:
		if (pr) {
			blkid_free_probe(pr);
		}

### extern void blkid_reset_probe(blkid_probe pr);

void
blkid_reset_probe(_pr)
	SV *_pr
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_reset_probe");
	CODE:
		if (pr) {
			blkid_reset_probe(pr);
		}


### extern int blkid_probe_set_device(blkid_probe pr, int fd,
### 	                blkid_loff_t off, blkid_loff_t size);
# // TODO: Completely useless? Again, using file descriptors

int
blkid_probe_set_device(_pr, fd, off, size)
	SV *_pr
	int fd
	int64_t off
	int64_t size
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_probe_set_device");
	CODE:
		if (pr) {
			RETVAL = blkid_probe_set_device(pr, fd, off, size);
		} else {
			XSRETURN_UNDEF;
		}
	OUTPUT:
		RETVAL

		
	

### extern int blkid_probe_set_request(blkid_probe pr, int flags);

int
blkid_probe_set_request(_pr, flags)
	SV *_pr
	int flags
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_probe_set_request");
	CODE:
		if (!pr) {
			XSRETURN_UNDEF;
		}

		RETVAL = blkid_probe_set_request(pr, flags);

	OUTPUT:
		RETVAL


### extern int blkid_probe_filter_usage(blkid_probe pr, int flag, int usage);


int
blkid_probe_filter_usage(_pr, flag, usage)
	SV *_pr
	int flag
	int usage
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_probe_filter_usage");
	CODE:
		if (!pr) {
			XSRETURN_UNDEF;
		}

		RETVAL = blkid_probe_filter_usage(pr, flag, usage);

	OUTPUT:
		RETVAL
	

### extern int blkid_probe_filter_types(blkid_probe pr,
### 			int flag, char *names[]);

# // TODO XXX TODO XXX Segfaults :(

int
blkid_probe_filter_types(_pr, flag, _names)
	SV *_pr
	int flag
	AV *_names
	PREINIT:
		char **names;
		I32 num; 
		blkid_probe pr;
		int i;
		int ok;
		SV **_s;
		char *s;
	INIT:
		pr = sv2probe(_pr, "blkid_probe_filter_types");
	CODE:
		if (!pr) {
			XSRETURN_UNDEF;
		}
		num = av_len(_names) + 1;
		if (num < 1) {
			XSRETURN_UNDEF;
		}
		names = malloc(sizeof(char *) * num);
		for (i = 0; i < num; i++) {
			ok = 0;
			_s = av_fetch(_names, i, 0);
			if (_s) {
				if (SvOK(*_s)) {
					if (SvPOK(*_s)) {
						ok = 1;
						s = SvPV_nolen(*_s);
					}
				}
			}

			if (ok) {
				names[i] = s;
			} else {
				names[i] = ""; //  XXX or rather NULL?
			}
		}

		for (i = 0; i < num; i++) {
			printf("name %d is %s\n", i, names[i]);
		}

		RETVAL = blkid_probe_filter_types(pr, flag, names);

		free(names);
	OUTPUT:
		RETVAL


### extern int blkid_probe_invert_filter(blkid_probe pr);

int
blkid_probe_invert_filter(_pr)
	SV *_pr
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_probe_invert_filter");
	CODE:
		if (!pr) {
			XSRETURN_UNDEF;
		}
		RETVAL = blkid_probe_invert_filter(pr);
	OUTPUT:
		RETVAL

### extern int blkid_probe_reset_filter(blkid_probe pr);

int
blkid_probe_reset_filter(_pr)
	SV *_pr
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_probe_reset_filter");
	CODE:
		if (!pr) {
			XSRETURN_UNDEF;
		}
		RETVAL = blkid_probe_reset_filter(pr);
	OUTPUT:
		RETVAL


### extern int blkid_do_probe(blkid_probe pr);

int
blkid_do_probe(_pr)
	SV *_pr
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_do_probe");
	CODE:
		if (!pr) {
			XSRETURN_UNDEF;
		}
		RETVAL = blkid_do_probe(pr);
	OUTPUT:
		RETVAL




### extern int blkid_do_safeprobe(blkid_probe pr);

int
blkid_do_safeprobe(_pr)
	SV *_pr
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_do_safeprobe");
	CODE:
		if (!pr) {
			XSRETURN_UNDEF;
		}
		RETVAL = blkid_do_safeprobe(pr);
	OUTPUT:
		RETVAL


### extern int blkid_probe_numof_values(blkid_probe pr);

int
blkid_probe_numof_values(_pr)
	SV *_pr
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_probe_numof_values");
	CODE:
		if (!pr) {
			XSRETURN_UNDEF;
		}
		RETVAL = blkid_probe_numof_values(pr);
	OUTPUT:
		RETVAL


### extern int blkid_probe_get_value(blkid_probe pr, int num, const char **name,
###                         const char **data, size_t *len);

SV *
blkid_probe_get_value(_pr, num)
	SV *_pr
	int num
	INIT:
		HV *rh = NULL;
		const char *name;
		const char *data;
		size_t len;
		int ret;

		blkid_probe pr = sv2probe(_pr, "blkid_probe_get_value");
	PPCODE:
		if (pr) {
			ret = blkid_probe_get_value(pr, num, &name, &data, &len);

			if (ret == 0) {
				rh = (HV *)sv_2mortal((SV *)newHV());

				hv_store(rh, "name", 4, newSVpv(name, 0), 0);
				hv_store(rh, "data", 4, newSVpv(data, 0), 0);

				XPUSHs(sv_2mortal(newRV((SV *) rh)));
			} else {
				XPUSHs(&PL_sv_undef);
			}
		} else {
			XPUSHs(&PL_sv_undef);
		}



### extern int blkid_probe_lookup_value(blkid_probe pr, const char *name,
###                         const char **data, size_t *len);

SV *
blkid_probe_lookup_value(_pr, name)
	SV *_pr
	const char *name
	INIT:
		const char *data;
		size_t len;
		int ret;
		SV *_data;

		blkid_probe pr = sv2probe(_pr, "blkid_probe_lookup_value");
	PPCODE:
		if (pr) {
			if (blkid_probe_lookup_value(pr, name, &data, &len) == 0) {
				XPUSHs(sv_2mortal(newSVpv(data, len)));
			} else {
				XPUSHs(&PL_sv_undef);
			}
		} else {
			XPUSHs(&PL_sv_undef);
		}


### extern int blkid_probe_has_value(blkid_probe pr, const char *name);

int
blkid_probe_has_value(_pr, name)
	SV *_pr
	const char *name
	INIT:
		blkid_probe pr = sv2probe(_pr, "blkid_probe_has_value");
	CODE:
		if (pr) {
			RETVAL = blkid_probe_has_value(pr, name);
		} else {
			XSRETURN_UNDEF;
		}
	OUTPUT:
		RETVAL


=cut

package Device::Blkid::Device;

=head1 Package C<Device::Blkid::Device>

Objects of this type are returned by a number of functions in the
C<Device::Blkid> package. They cannot be user-created and are
(almost) only expected to be passed to other functions of C<Device::Blkid>.

A single object method exists:

=head1 METHODS

=head2 Method C<toHash()>

Returns the tags of this device as a hash, e.g.

 $VAR1 = {
 	'TYPE'	=> 'swap',
	'UUID'	=> '12345678-1234-1234-1234-123457890123',
 };

This method uses L<Device::Blkid::blkid_tag_iterate_begin>,
L<Device::Blkid::blkid_tag_next>, and
L<Device::Blkid::blkid_tag_iterate_end> to iterate over the device tags;
you might as well call these functions yourself.

=cut

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

package Device::Blkid::DevIterate;

sub DESTROY {
	my ($self) = @_;
	Device::Blkid::_DO_blkid_dev_iterate_end($self);
}

package Device::Blkid::TagIterate;

sub DESTROY {
	my ($self) = @_;
	Device::Blkid::_DO_blkid_tag_iterate_end($self);
}

1;

=head1 AUTHOR

Bastian Friedrich, C<< <bastian.friedrich at collax.com> >>

=head1 BUGS

Device::Blkid 0.9 is expected to contain a number of memory leaks.

Please report any bugs or feature requests to C<bug-device-blkid at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Device-Blkid>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Device::Blkid


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Device-Blkid>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Device-Blkid>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Device-Blkid>

=item * Search CPAN

L<http://search.cpan.org/dist/Device-Blkid/>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 Bastian Friedrich.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
