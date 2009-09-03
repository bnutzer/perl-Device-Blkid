/*
 * $Id: Blkid.xs,v 1.4 2009/09/03 14:55:05 bastian Exp $
 *
 * Copyright (C) 2009 Collax GmbH
 *                    (Bastian Friedrich <bastian.friedrich@collax.com>)
 */

#include <unistd.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <blkid/blkid.h>

/*
 * Bad code
 * TODO
 * _one_ function that does the same job...
 */
blkid_cache sv2cache(SV *sv, char *func) {
	blkid_cache cache = NULL;
	char err[256] = "Cache error";
	if (SvROK(sv)) {
		if (sv_derived_from(sv, "Device::Blkid::Cache")) {
			sv = SvRV(sv);
			if (SvIOK(sv)) {
				cache = INT2PTR(blkid_cache, SvIV(sv));
			} else {
				snprintf(err, sizeof(err)-1, "%s: Invalid argument (internal error)", func);
			}
		} else {
			snprintf(err, sizeof(err)-1, "%s: Invalid argument (not a Device::Blkid::Cache object)", func);
		}
	} else {
		snprintf(err, sizeof(err)-1, "%s: Invalid argument (not an object)", func);
	}
	if (!cache)
		warn(err);

	return cache; /* In case of error above... */
}


blkid_dev sv2dev(SV *sv, char *func) {
	blkid_dev dev= NULL;
	char err[256] = "Device error";
	if (SvROK(sv)) {
		if (sv_derived_from(sv, "Device::Blkid::Device")) {
			sv = SvRV(sv);
			if (SvIOK(sv)) {
				dev = INT2PTR(blkid_dev, SvIV(sv));
			} else {
				snprintf(err, sizeof(err)-1, "%s: Invalid argument (internal error)", func);
			}
		} else {
			snprintf(err, sizeof(err)-1, "%s: Invalid argument (not a Device::Blkid::Device object)", func);
		}
	} else {
		snprintf(err, sizeof(err)-1, "%s: Invalid argument (not an object)", func);
	}
	if (!dev)
		warn(err);

	return dev; /* In case of error above... */
}


blkid_probe sv2probe(SV *sv, char *func) {
	blkid_probe probe = NULL;
	char err[256] = "Probe error";
	if (SvROK(sv)) {
		if (sv_derived_from(sv, "Device::Blkid::Probe")) {
			sv = SvRV(sv);
			if (SvIOK(sv)) {
				probe = INT2PTR(blkid_probe, SvIV(sv));
			} else {
				snprintf(err, sizeof(err)-1, "%s: Invalid argument (internal error)", func);
			}
		} else {
			snprintf(err, sizeof(err)-1, "%s: Invalid argument (not a Device::Blkid::Probe object)", func);
		}
	} else {
		snprintf(err, sizeof(err)-1, "%s: Invalid argument (not an object)", func);
	}
	if (!probe)
		warn(err);

	return probe; /* In case of error above... */
}


MODULE = Device::Blkid PACKAGE = Device::Blkid

### typedef struct blkid_struct_dev *blkid_dev;
### typedef struct blkid_struct_cache *blkid_cache;
### typedef struct blkid_struct_probe *blkid_probe;
### 
### typedef int64_t blkid_loff_t;
### 
### typedef struct blkid_struct_tag_iterate *blkid_tag_iterate;
### typedef struct blkid_struct_dev_iterate *blkid_dev_iterate;
### 
### 
### 
### /* cache.c */
### extern void blkid_put_cache(blkid_cache cache);

# //  TODO: Segfaults XXX TODO XXX
# // Subsequent calls segfault (not the call to put_cache itself)
SV *
blkid_put_cache(cache)
	SV *cache
	PREINIT:
		blkid_cache real_cache = sv2cache(cache, "blkid_put_cache");
	PPCODE:
		if (real_cache) {
			blkid_put_cache(real_cache);
			XPUSHs(sv_2mortal(newSViv(1)));
		} else {
			XPUSHs(&PL_sv_undef);
		}


### extern int blkid_get_cache(blkid_cache *cache, const char *filename);

SV *
_blkid_get_cache(sv_filename)
	SV *sv_filename
	PREINIT:
		blkid_cache real_cache;
		SV *cache;
		int ret;
		char *filename;
	PPCODE:

		if (SvOK(sv_filename)) { filename = SvPV_nolen(sv_filename); } else { filename = NULL; }

		if ((ret = blkid_get_cache(&real_cache, filename)) != 0) {
			warn("error creating cache (%d)\n", ret);
			XPUSHs(&PL_sv_undef);
		} else {
			cache = sv_newmortal();
			sv_setref_pv(cache, "Device::Blkid::Cache", (void *)real_cache);
			SvREADONLY_on(SvRV(cache));
			XPUSHs(cache);
		}



### extern void blkid_gc_cache(blkid_cache cache);

SV *
blkid_gc_cache(cache)
	SV *cache
	PREINIT:
		blkid_cache real_cache = sv2cache(cache, "blkid_gc_cache");
	PPCODE:
		if (real_cache) {
			blkid_gc_cache(real_cache);
			XPUSHs(sv_2mortal(newSViv(1)));
		} else {
			XPUSHs(&PL_sv_undef);
		}

### /* dev.c */
### extern const char *blkid_dev_devname(blkid_dev dev);
SV *
blkid_dev_devname(dev)
	SV *dev
	PREINIT:
		blkid_dev real_dev = sv2dev(dev, "blkid_dev_devname");
		const char *ret;
	PPCODE:
		if (ret = blkid_dev_devname(real_dev)) {
			XPUSHs(sv_2mortal(newSVpv(ret, 0)));
		} else {
			XPUSHs(&PL_sv_undef);
		}


### // TODO XXX TODO XXX
### extern blkid_dev_iterate blkid_dev_iterate_begin(blkid_cache cache);
### extern int blkid_dev_set_search(blkid_dev_iterate iter,
### 				char *search_type, char *search_value);
### extern int blkid_dev_next(blkid_dev_iterate iterate, blkid_dev *dev);
### extern void blkid_dev_iterate_end(blkid_dev_iterate iterate);
### 


#
# blkid_devno_to_devname(devno)
#
# Returns devicename of device number major*256+minor
# Perl wrapper for correct argument types
#

SV *
_blkid_devno_to_devname(devno)
	dev_t devno
	PREINIT:
		blkid_cache cache = NULL;
		char *ret;
	PPCODE:
		blkid_get_cache(&cache, NULL);
		ret = blkid_devno_to_devname(devno);
		if (ret) {
			XPUSHs(sv_2mortal(newSVpv(ret, 0)));
		} else {
			XPUSHs(&PL_sv_undef);
		}


### /* devname.c */
### extern int blkid_probe_all(blkid_cache cache);

SV *
blkid_probe_all(cache)
	SV *cache
	PREINIT:
		blkid_cache real_cache = sv2cache(cache, "blkid_probe_all");
		int ret;
	PPCODE:
		if (real_cache) {
			ret = blkid_probe_all(real_cache);
			XPUSHs(sv_2mortal(newSViv(ret)));
		} else {
			XPUSHs(&PL_sv_undef);
		}

### extern int blkid_probe_all_new(blkid_cache cache);

SV *
blkid_probe_all_new(cache)
	SV *cache
	PREINIT:
		blkid_cache real_cache = sv2cache(cache, "blkid_probe_all_new");
		int ret;
	PPCODE:
		if (real_cache) {
			ret = blkid_probe_all_new(real_cache);
			XPUSHs(sv_2mortal(newSViv(ret)));
		} else {
			XPUSHs(&PL_sv_undef);
		}



### extern blkid_dev blkid_get_dev(blkid_cache cache, const char *devname,
### 			       int flags);


SV *
blkid_get_dev(cache, _devname, flags)
	SV *cache
	SV *_devname
	IV flags
	PREINIT:
		blkid_cache real_cache = sv2cache(cache, "blkid_probe_all_new");
		char *devname = NULL;
		blkid_dev dev;
		SV *_dev;
	PPCODE:
		if (!SvOK(_devname)) {
			warn("blkid_get_dev: invalid devname argument");
		} else {
			if (!SvPOK(_devname)) {
				warn("blkid_get_dev: invalid devname argument");
			} else {
				devname = SvPV_nolen(_devname);
			}
		}

		if (devname) {
			dev = blkid_get_dev(real_cache, devname, flags);
			_dev = sv_newmortal();
			sv_setref_pv(_dev, "Device::Blkid::Device", (void *)dev);
			SvREADONLY_on(SvRV(_dev));
			XPUSHs(_dev);
		} else {
			XPUSHs(&PL_sv_undef);
		}



### /* getsize.c */
### extern blkid_loff_t blkid_get_dev_size(int fd);
# // TODO XXX
# // Frankly, this is senseless -- we do not have fd access from perl

IV
blkid_get_dev_size(fd)
	IV fd
	CODE:
		RETVAL = blkid_get_dev_size(fd);
	OUTPUT:
		RETVAL

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

SV *
blkid_get_tag_value(_cache, tagname, devname)
	SV *_cache
	char *tagname
	char *devname
	PREINIT:
		blkid_cache cache = sv2cache(_cache, "blkid_get_tag_value");
		char *ret;
	PPCODE:
		ret = blkid_get_tag_value(cache, tagname, devname);
		if (ret) {
			XPUSHs(sv_2mortal(newSVpv(ret, 0)));
		} else {
			XPUSHs(&PL_sv_undef);
		}

		

### extern char *blkid_get_devname(blkid_cache cache, const char *token,
### 			       const char *value);
### 
### /* tag.c */
### extern blkid_tag_iterate blkid_tag_iterate_begin(blkid_dev dev);
### extern int blkid_tag_next(blkid_tag_iterate iterate,
### 			      const char **type, const char **value);
### extern void blkid_tag_iterate_end(blkid_tag_iterate iterate);
### extern int blkid_dev_has_tag(blkid_dev dev, const char *type,
### 			     const char *value);
### extern blkid_dev blkid_find_dev_with_tag(blkid_cache cache,
### 					 const char *type,
### 					 const char *value);
### extern int blkid_parse_tag_string(const char *token, char **ret_type,
### 				  char **ret_val);
### 
### /* version.c */
### extern int blkid_parse_version_string(const char *ver_string);
### extern int blkid_get_library_version(const char **ver_string,
### 				     const char **date_string);
### 
### /* encode.c */
### extern int blkid_encode_string(const char *str, char *str_enc, size_t len);
### extern int blkid_safe_string(const char *str, char *str_safe, size_t len);
### 
### /* evaluate.c */
### extern int blkid_send_uevent(const char *devname, const char *action);



### extern char *blkid_evaluate_tag(const char *token, const char *value,
### 				blkid_cache *cache);
### 
### /* probe.c */
### extern int blkid_known_fstype(const char *fstype);
### extern blkid_probe blkid_new_probe(void);
### extern void blkid_free_probe(blkid_probe pr);
### extern void blkid_reset_probe(blkid_probe pr);
### 
### extern int blkid_probe_set_device(blkid_probe pr, int fd,
### 	                blkid_loff_t off, blkid_loff_t size);
### 
### extern int blkid_probe_set_request(blkid_probe pr, int flags);
### 
### extern int blkid_probe_filter_usage(blkid_probe pr, int flag, int usage);
### 
### extern int blkid_probe_filter_types(blkid_probe pr,
### 			int flag, char *names[]);
### 
### 
### extern int blkid_probe_invert_filter(blkid_probe pr);
### extern int blkid_probe_reset_filter(blkid_probe pr);
### 
### extern int blkid_do_probe(blkid_probe pr);
### extern int blkid_do_safeprobe(blkid_probe pr);
### 
### extern int blkid_probe_numof_values(blkid_probe pr);
### extern int blkid_probe_get_value(blkid_probe pr, int num, const char **name,
###                         const char **data, size_t *len);
### extern int blkid_probe_lookup_value(blkid_probe pr, const char *name,
###                         const char **data, size_t *len);
### extern int blkid_probe_has_value(blkid_probe pr, const char *name);
