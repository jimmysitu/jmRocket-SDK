#=======================================================================
# UCB VLSI FLOW: Makefile for jmRocket
#-----------------------------------------------------------------------
# Jimmy Situ (http://www.github.com/jimmysitu)
#

XLEN ?= 64

COV ?= 1

default: all

src_dir = ..

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

tests = \
	test_gcov \

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_PREFIX ?= riscv$(XLEN)-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_LINK ?= $(RISCV_PREFIX)ld

RISCV_GCC_OPTS ?= -DPREALLOCATE=1 -mcmodel=medany -static -nostdlib -nostartfiles -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -g
RISCV_LINK_OPTS ?= -static -nostdlib -nostartfiles

ifeq ($(COV), 1)
GCOV_OPTS ?= --coverage -fprofile-info-section -ffunction-sections -fdata-sections -flto

RISCV_LINK_OPTS += --coverage -T $(src_dir)/common/test_gcov.ld
else
RISCV_LINK_OPTS += -T $(src_dir)/common/test.ld 
endif

RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump
RISCV_OBJDUMP_OPTS ?= -D -S
RISCV_SIM ?= spike --isa=rv$(XLEN)gc

incs  += -I$(src_dir)/../env -I$(src_dir)/common $(addprefix -I$(src_dir)/, $(tests))

objs  :=

LIST_OPTS ?= -g -Wa,-aslh

ifeq ($(COV), 1)
define compile_template
$(1).riscv: $(wildcard $(src_dir)/$(1)/*) $(wildcard $(src_dir)/common/*)
	$$(RISCV_GCC) $$(incs) $$(RISCV_GCC_OPTS) $$(GCOV_OPTS) -c \
		$(wildcard $(src_dir)/$(1)/*.c) \
		$(wildcard $(src_dir)/$(1)/*.S) \
		$(wildcard $(src_dir)/common/*.c) \
		$(wildcard $(src_dir)/common/*.S)
	
	$$(RISCV_GCC) $$(RISCV_LINK_OPTS) *.o -Wl,-Map=$$@.map -Wl,--gc-sections -o $$@
endef

else
define compile_template
$(1).riscv: $(wildcard $(src_dir)/$(1)/*) $(wildcard $(src_dir)/common/*)
	$$(RISCV_GCC) $$(incs) $$(RISCV_GCC_OPTS) -o $$@ $$(LIST_OPTS) \
		$(wildcard $(src_dir)/$(1)/*.c) \
		$(wildcard $(src_dir)/$(1)/*.S) \
		$(wildcard $(src_dir)/common/*.c) \
		$(wildcard $(src_dir)/common/*.S) \
		$$(RISCV_LINK_OPTS) > $$@.lst

endef

endif

$(foreach bmark,$(tests),$(eval $(call compile_template,$(bmark))))

#------------------------------------------------------------
# Build and run benchmarks on riscv simulator

tests_riscv_bin  = $(addsuffix .riscv,  $(tests))
tests_riscv_dump = $(addsuffix .riscv.dump, $(tests))
tests_riscv_out  = $(addsuffix .riscv.out,  $(tests))
tests_riscv_lst  = $(addsuffix .riscv.lst,  $(tests))

$(tests_riscv_dump): %.riscv.dump: %.riscv
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_OPTS) $< > $@
	$(RISCV_OBJDUMP) -t $< > $<.symb

$(tests_riscv_out): %.riscv.out: %.riscv
	$(RISCV_SIM) $< > $@

riscv: $(tests_riscv_dump)
run: $(tests_riscv_out)

junk += $(tests_riscv_bin) $(tests_riscv_dump) $(tests_riscv_hex) $(tests_riscv_out)
junk += $(tests_riscv_lst)

#------------------------------------------------------------
# Default

all: riscv

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(objs) $(junk)
	rm *.o
	rm *.gcno
	rm *.symb

