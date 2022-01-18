// -----
// Minimal snipped from Jitify which triggers the error.
#define NOMINMAX
#if defined(_WIN32)
#include <Windows.h>
#endif
// -----
#include <cub/cub.cuh>
int main(int artc, char* argv[]) {
    return EXIT_SUCCESS;
}
