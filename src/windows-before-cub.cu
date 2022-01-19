// Including windows.h before cub/cub.cuh for CUB 1.5.0 results in a compile error.
#if defined(_WIN32)
    #include <Windows.h>
    #pragma push_macro("small")
    #undef small
#endif
#include <cub/cub.cuh>
#if defined(_WIN32)
    #pragma pop_macro("small")
#endif
int main(int argc, char* argv[]) {
    return EXIT_SUCCESS;
}
