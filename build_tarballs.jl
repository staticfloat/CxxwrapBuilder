using BinaryBuilder

# Collection of sources required to build Ogg
sources = [
    "https://github.com/JuliaInterop/libcxxwrap-julia/archive/v0.2.3.tar.gz" =>
    "705261b9c3e73a501284fc465d15b85bc17f2864cd7c261d5267de7350f9bce6",
]

# Bash recipe for building across all platforms
script = raw"""
# Download julia
cd /usr/local
curl -L 'https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.3-linux-x86_64.tar.gz' | tar -zx --strip-components=1

# Build libcxxwrap
cd $WORKSPACE/srcdir/libcxxwrap-julia*
mkdir build && cd build
cmake -DJulia_EXECUTABLE=$(which julia) -DCMAKE_INSTALL_PREFIX=${prefix} ..
VERBOSE=ON cmake --build . --config Debug --target install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, :glibc),
]

# The products that we will ensure are always built
products = prefix -> [
    LibraryProduct(prefix, "libcxxwrap", :libcxxwrap),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "Cxxwrap", sources, script, platforms, products, dependencies)
