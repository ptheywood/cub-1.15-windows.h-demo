#include <cub/cub.cuh>
// -----
// Minimal snipped from Jitify which triggers the error.
#define NVRTC_GET_TYPE_NAME 1
#include <nvrtc.h>
// -----
int main(int artc, char* argv[]) {
    return EXIT_SUCCESS;
}
