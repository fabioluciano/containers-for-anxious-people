#include <stdio.h> // <1>
#include <unistd.h> // <1>

void main () {
  printf(":)\n"); // <2>
  usleep(520000*1000);
}
