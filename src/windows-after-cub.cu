#include <cub/cub.cuh>
// Including windows.h after cub/cub.cuh for CUB 1.5.0 compiles successfully
#if defined(_WIN32)
    #include <Windows.h>
#endif
int main(int argc, char* argv[]) {
    return EXIT_SUCCESS;
}
