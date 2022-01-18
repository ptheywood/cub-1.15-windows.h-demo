#include <cub/cub.cuh>
// -----
// Actually it's just Windows.h, which is included in jitify via nvrtc when NVRTC_GET_TYPE_NAME is set to 1.
#if defined(_WIN32)
#include <Windows.h>
#endif
// -----
int main(int artc, char* argv[]) {
    return EXIT_SUCCESS;
}
