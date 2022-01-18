// Including windows.h before cub/cub.cuh for CUB 1.5.0 results in a compile error.
#if defined(_WIN32)
    #include <Windows.h>
#endif
#include <cub/cub.cuh>
int main(int argc, char* argv[]) {
    return EXIT_SUCCESS;
}
