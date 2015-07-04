# Output variables:
# libvpx_config_dir_x86
# libvpx_codec_srcs_c_x86
# libvpx_codec_srcs_asm_x86

libvpx_target := generic

YASM := prebuilts/misc/$(BUILD_OS)-$(HOST_PREBUILT_ARCH)/yasm/yasm

libvpx_config_dir_x86 := $(LOCAL_PATH)/$(libvpx_target)
libvpx_codec_srcs := $(sort $(shell cat $(libvpx_config_dir_x86)/libvpx_srcs.txt))

# vpx_config.c is an auto-generated file in $(libvpx_target).
libvpx_codec_srcs_c_x86 := $(addprefix libvpx/, $(filter-out vpx_config.c, \
    $(filter %.c, $(libvpx_codec_srcs)))) \
    $(libvpx_target)/vpx_config.c

libvpx_codec_srcs_asm_x86 := $(filter %.asm.s, $(libvpx_codec_srcs))
