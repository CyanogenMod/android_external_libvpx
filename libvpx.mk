LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

ifeq ($(ARCH_ARM_HAVE_NEON),true)
  libvpx_target := armv7a-neon
  libvpx_asm := .asm.s
else ifeq ($(ARCH_ARM_HAVE_ARMV7A),true)
  libvpx_target := armv7a
  libvpx_asm := .asm.s
endif

ifeq ($(TARGET_ARCH),mips)
  ifneq ($(ARCH_HAS_BIGENDIAN),true)
    ifeq ($(ARCH_MIPS_DSP_REV),2)
      libvpx_target := mips-dspr2
    else
      libvpx_target := mips
    endif #mips_dsp_rev2
  endif #bigendian
endif #mips

# Un-optimized targets
libvpx_target ?= generic
libvpx_asm ?= .asm

libvpx_config_dir := $(LOCAL_PATH)/$(libvpx_target)
libvpx_source_dir := $(LOCAL_PATH)/libvpx

libvpx_codec_srcs := $(shell cat $(libvpx_config_dir)/libvpx_srcs.txt)

LOCAL_CFLAGS := -DHAVE_CONFIG_H=vpx_config.h

LOCAL_MODULE := libvpx

LOCAL_MODULE_CLASS := STATIC_LIBRARIES

# Extract the C files from the list and add them to LOCAL_SRC_FILES.
libvpx_codec_srcs_unique := $(sort $(libvpx_codec_srcs))
libvpx_codec_srcs_c := $(filter %.c, $(libvpx_codec_srcs_unique))
# vpx_config.c is an auto-generated file in $(config_dir)
libvpx_codec_srcs_c_static := $(filter-out vpx_config.c, $(libvpx_codec_srcs_c))
LOCAL_SRC_FILES += $(addprefix libvpx/, $(libvpx_codec_srcs_c_static))
LOCAL_SRC_FILES += $(libvpx_target)/vpx_config.c

libvpx_2nd_arch :=
include $(LOCAL_PATH)/libvpx-offsets.mk
ifdef TARGET_2ND_ARCH
libvpx_2nd_arch := $(TARGET_2ND_ARCH_VAR_PREFIX)
include $(LOCAL_PATH)/libvpx-offsets.mk
endif
libvpx_2nd_arch :=

LOCAL_C_INCLUDES := \
    $(libvpx_source_dir) \
    $(libvpx_config_dir) \
    $(libvpx_intermediates)/vp8/common \
    $(libvpx_intermediates)/vp8/decoder \
    $(libvpx_intermediates)/vp8/encoder \
    $(libvpx_intermediates)/vpx_scale \

libvpx_target :=
libvpx_asm :=
libvpx_config_dir :=
libvpx_source_dir :=
libvpx_codec_srcs :=
libvpx_intermediates :=
libvpx_codec_srcs_unique :=
libvpx_codec_srcs_c :=
libvpx_codec_srcs_c_static :=
libvpx_asm_offsets_intermediates :=
libvpx_asm_offsets_files :=
libvpx_asm_srcs :=

LOCAL_32_BIT_ONLY := true

include $(BUILD_STATIC_LIBRARY)
