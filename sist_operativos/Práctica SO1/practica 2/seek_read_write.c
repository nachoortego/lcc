#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>

char seek_read(int fd, off_t pos) {
    lseek(fd, pos, SEEK_SET);
    char buff;
    if (read(fd, &buff, 1) < 0) {
        perror("read");
        exit(EXIT_FAILURE);
    }
    return buff;
}

void seek_write(int fd, off_t pos, const char c) {
    lseek(fd, pos, SEEK_SET);
    write(fd, &c, 1);
}

int main() {

    int fd = open("example.txt", O_RDWR);

    __pid_t pid = fork();

    if (pid == 0) {
        char c = seek_read(fd, 13);
        printf("char read by child: %c\n", c);
        seek_write(fd, 13, 'A');
    }
    else {
        char c = seek_read(fd, 13);
        printf("char read by parent: %c\n", c);
        seek_write(fd, 13, 'B');
    }

    close(fd);

    return 0;
}