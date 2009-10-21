#include <stdio.h>
#include <iostream>

#include <blkid/blkid.h>

using namespace std;

int main(int argc, char *argv[]) {
	dev_t n = 2049;
	blkid_cache cache;
	blkid_get_cache(&cache, "/dev/blkid.tab");

	blkid_dev dev;

	dev = blkid_get_dev(cache, "/dev/sda1", 1);

	printf("swap is swap: %d\n", blkid_dev_has_tag(dev, "TYPE=swap", NULL));

}
