################################################################################
#
# cpuinfo
#
################################################################################

CPUINFO_VERSION = 39ea79a3c132f4e678695c579ea9353d2bd29968
CPUINFO_SITE = https://github.com/pytorch/cpuinfo.git
CPUINFO_SITE_METHOD = git

CPUINFO_INSTALL_STAGING = YES

CPUINFO_LICENSE = BSD2
CPUINFO_LICENSE_FILE = LICENSE

CPUINFO_DEPENDENCIES = host-libcurl

CPUINFO_CONF_OPTS  = -DCMAKE_BUILD_TYPE=Release
CPUINFO_CONF_OPTS += -DBUILD_SHARED_LIBS=FALSE

# LZ FIX: desativa testes/benchmarks
CPUINFO_CONF_OPTS += -DCPUINFO_BUILD_TOOLS=OFF
CPUINFO_CONF_OPTS += -DCPUINFO_BUILD_UNIT_TESTS=OFF
CPUINFO_CONF_OPTS += -DCPUINFO_BUILD_BENCHMARKS=OFF
CPUINFO_CONF_OPTS += -DCPUINFO_BUILD_MOCK_TESTS=OFF
CPUINFO_CONF_OPTS += -DCPUINFO_BUILD_TESTS=OFF
CPUINFO_CONF_OPTS += -DBUILD_TESTING=OFF
CPUINFO_CONF_OPTS += -DBUILD_BENCHMARKS=OFF

# LZ FIX: troca downloads HTTP por HTTPS caso o CMake ainda tente baixar googlebenchmark/googletest
define CPUINFO_FIX_GITHUB_HTTP_URLS
	$(SED) 's#http://github.com/#https://github.com/#g' $(@D)/CMakeLists.txt
	$(SED) 's#http://github.com#https://github.com#g' $(@D)/CMakeLists.txt
	$(SED) 's#http://github.com/#https://github.com/#g' $(@D)/cmake/*.cmake
	$(SED) 's#http://github.com#https://github.com#g' $(@D)/cmake/*.cmake
endef
CPUINFO_POST_PATCH_HOOKS += CPUINFO_FIX_GITHUB_HTTP_URLS

CPUINFO_CONF_ENV += LDFLAGS=-lpthread

$(eval $(cmake-package))
