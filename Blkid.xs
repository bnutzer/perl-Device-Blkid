/*
 * $Id: Blkid.xs,v 1.1 2009/08/31 22:48:04 bastian Exp $
 *
 * Copyright (C) 2009 Collax GmbH
 *                    (Bastian Friedrich <bastian.friedrich@collax.com>)
 */

#include <unistd.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <blkid/blkid.h>

MODULE = Sys::Blkid PACKAGE = Sys::Blkid

SV *
blkid_devno_to_devname(devno)
	int devno
	PREINIT:
		blkid_cache cache = NULL;
	PPCODE:
		blkid_get_cache(&cache, NULL);
		XPUSHs(sv_2mortal(newSVpv(blkid_devno_to_devname(devno), 0)));



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
### extern int blkid_get_cache(blkid_cache *cache, const char *filename);
### extern void blkid_gc_cache(blkid_cache cache);
### 
### /* dev.c */
### extern const char *blkid_dev_devname(blkid_dev dev);
### 
### extern blkid_dev_iterate blkid_dev_iterate_begin(blkid_cache cache);
### extern int blkid_dev_set_search(blkid_dev_iterate iter,
### 				char *search_type, char *search_value);
### extern int blkid_dev_next(blkid_dev_iterate iterate, blkid_dev *dev);
### extern void blkid_dev_iterate_end(blkid_dev_iterate iterate);
### 
### /* devno.c */
### extern char *blkid_devno_to_devname(dev_t devno);
### 
### /* devname.c */
### extern int blkid_probe_all(blkid_cache cache);
### extern int blkid_probe_all_new(blkid_cache cache);
### extern blkid_dev blkid_get_dev(blkid_cache cache, const char *devname,
### 			       int flags);
### 
### /* getsize.c */
### extern blkid_loff_t blkid_get_dev_size(int fd);
### 
### /* verify.c */
### extern blkid_dev blkid_verify(blkid_cache cache, blkid_dev dev);
### 
### /* read.c */
### 
### /* resolve.c */
### extern char *blkid_get_tag_value(blkid_cache cache, const char *tagname,
### 				       const char *devname);
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
