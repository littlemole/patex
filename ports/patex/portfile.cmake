# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO littlemole/patex
    REF 0.0.3
    SHA512 d7ac5e1a055ba00715b42366a0ec90e36ccc67379c0f3a256d155f0495fb1eccc1f62889ae3b845ccda03d8144f6d2dbf313adbfa74fc67d9e92d7344793229d
    HEAD_REF main
#    [PATCHES <patch1.patch> <patch2.patch>...]
#    [GITHUB_HOST <https://github.com>]
#    [AUTHORIZATION_TOKEN <${SECRET_FROM_FILE}>]
#    [FILE_DISAMBIGUATOR <N>]
)

#include(vcpkg_common_functions)
#set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/patex-0.0.3)
#vcpkg_download_distfile(ARCHIVE
#    URLS "https://github.com/littlemole/patex/archive/0.0.3.tar.gz"
#    FILENAME "patex-0.0.3.tgz"
#    SHA512 d7ac5e1a055ba00715b42366a0ec90e36ccc67379c0f3a256d155f0495fb1eccc1f62889ae3b845ccda03d8144f6d2dbf313adbfa74fc67d9e92d7344793229d
#)
#vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/patex RENAME copyright)


 file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include
	 )
