# CUB-1.15.0 and Windows.h compiler error

This repository demonstrated compilation errors in CUB 1.15.0 under MSVC, when `Windows.h` is included prior to the inclusion of `cub/cub.cuh`.

**This has been fixed in CUB/Thrust [1.16.0](https://github.com/NVIDIA/cub/releases/tag/1.16.0) by [NVIDIA/cub#423](https://github.com/NVIDIA/cub/pull/423)**.

## The Issue

i.e. `src/windows-before-cub.cu`

```c++
#if defined(_WIN32)
    #include <Windows.h>
#endif
#include <cub/cub.cuh>
int main(int argc, char* argv[]) {
    return EXIT_SUCCESS;
}
```

Which when compiled will lead to compiler errors:

```bash
D:/a/jitify-cub-1.15-MSVC-demo/jitify-cub-1.15-MSVC-demo/build/_deps/thrust-src/dependencies/cub\cub/device/dispatch/dispatch_segmented_sort.cuh(338): error : invalid combination of type specifiers [D:\a\jitify-cub-1.15-MSVC-demo\jitify-cub-1.15-MSVC-demo\build\jitify-before-cub.vcxproj]
D:/a/jitify-cub-1.15-MSVC-demo/jitify-cub-1.15-MSVC-demo/build/_deps/thrust-src/dependencies/cub\cub/device/dispatch/dispatch_segmented_sort.cuh(338): error : expected an identifier [D:\a\jitify-cub-1.15-MSVC-demo\jitify-cub-1.15-MSVC-demo\build\jitify-before-cub.vcxproj]
D:/a/jitify-cub-1.15-MSVC-demo/jitify-cub-1.15-MSVC-demo/build/_deps/thrust-src/dependencies/cub\cub/device/dispatch/dispatch_segmented_sort.cuh(379): error : expected a member name [D:\a\jitify-cub-1.15-MSVC-demo\jitify-cub-1.15-MSVC-demo\build\jitify-before-cub.vcxproj]
```

CUB 1.14.0 does not suffer from this issue.

This impacts the use of NVRTC and [NVIDIA/Jitify](https://github.com/NVIDIA/jitify), as `nvrtc.h` includes `Windows.h` if `NVRTC_GET_TYPE_NAME` is defined to a non-zero value (as used in Jitify).

Including `Windows.h` *after* including `cub/cub.cuh` compiles successfully, but this order cannot always be guaranteed.

See the [github actions](https://github.com/ptheywood/cub-1.15-windows.h-demo/actions) for build logs (if they were recent enough), otherwise the below instructions can be used to reproduce this behaviour.

## Reproduction Instructions

This repository contains a CMake project which can be used to fetch a specific version of the Thrust (and therefore CUB) repository and build two targets, demonstrating the impact of inclusion order.

CMake can be used from the command line or the GUI to achieve this. Command line instructions are included below.

By default, Thrust/CUB 1.15.0 will be fetched, demonstrating the issue.

```bash
mkdir -p build && cd build
cmake ..
# windows-after-cub compiles ok
cmake --build . --config Release --target windows-after-cub
# windows-before-cub will error with CUB 11.5.0
cmake --build . --config Release --target windows-before-cub
```

Older versions of Thrust/CUB can be fetched instead, using the `THRUST_TAG` and `THRUST_REMOTE` CMake variables, which may be passed to CMake at configuration time. 

I.e. to instead fetch Thrust 1.14.0 (in a separate build directory):

```bash
mkdir build-1.14 && cd build-1.14
cmake .. -DTHRUST_TAG=1.14.0
# windows-after-cub compiles ok
cmake --build . --config Release --target windows-after-cub
# windows-before-cub will compile ok with CUB 11.4.0
cmake --build . --config Release --target windows-before-cub
```

Some (older) CMake Versions may also require setting the `-A` and `-G` options. I.e. for a Visual Studio 2019 x64 build use:

```bash
cmake .. -A x64 -G "Visual Studio 16 2019"
```
