# jitify-cub-1.15-MSVC-demo

This repostiory demonstrates compialtion errors in CUB 1.15.0 under MSVC, when jitify.hpp is included prior to cub.

i.e. 

```c++
#include "jitify/jitify.hpp" // before CUB, MSVC compile error.
#include <cub/cub.cuh>
int main(int artc, char* argv[]) {
    return EXIT_SUCCESS;
}
```

MSVC will error with the following

```bash
_deps/thrust-src/dependencies/cub\cub/device/dispatch/dispatch_segmented_sort.cuh(338): error : invalid combi
nation of type specifiers 
```

If instead jitify is included after CUB, it builds ok. 

This is new with CUB 1.15.0.

See the github actions for build logs, otherwise the below instructions can be used to reproduce this behaviour.


## Instructions

Calling CMake from the command line, the following will demonstrate the compilation issue. Alternativly the same can be achieved via the CMake GUI.

```bash
mkdir -p build && cd build
cmake ..
# Jitify-after-cub compiles ok
cmake --build . --config Release --target jitify-after-cub
# Jifity-before-cub will error with CUB 11.5.0
cmake --build . --config Release --target jitify-before-cub
```

The CMake Cache Variables `THRUST_TAG` and `THRUST_REMOTE` may be used to change where Thrust is fetched from at CMake Configuraiton time. 

I.e. to instead fetch Thrust 1.14.0:

```bash
mkdir build-1.14 && cd build-1.14
cmake .. -DTHRUST_TAG=1.14.0
# Jitify-after-cub compiles ok
cmake --build . --config Release --target jitify-after-cub
# Jifity-before-cub will compile ok with  CUB 11.4.0
cmake --build . --config Release --target jitify-before-cub
```

Some (older) CMake Versions may also require setting the `-A` and `-G` options. I.e. for a Visual Studio 2019, 64x build add the following at configure time

```bash
`-A x64 -G "Visual Studio 16 2019"
```