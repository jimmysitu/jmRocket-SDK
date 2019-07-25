#=======================================================================
# UCB VLSI FLOW: Makefile for jmRocket
#-----------------------------------------------------------------------
# Jimmy Situ (http://www.github.com/jimmysitu)
#

XLEN ?= 64

default: all

src_dir = .

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

tests = \
	uart \
	leds \

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_PREFIX ?= riscv$(XLEN)-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_GCC_OPTS ?= -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -g
RISCV_LINK ?= $(RISCV_GCC) -T $(src_dir)/common/test.ld $(incs)
RISCV_LINK_OPTS ?= -static -nostdlib -nostartfiles -lm -lgcc -T $(src_dir)/common/test.ld
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.data
RISCV_SIM ?= spike --isa=rv$(XLEN)gc

incs  += -I$(src_dir)/../env -I$(src_dir)/common $(addprefix -I$(src_dir)/, $(tests))
objs  :=

define compile_template
$(1).riscv: $(wildcard $(src_dir)/$(1)/*) $(wildcard $(src_dir)/common/*)
	$$(RISCV_GCC) $$(incs) $$(RISCV_GCC_OPTS) -o $$@ $(wildcard $(src_dir)/$(1)/*.c) $(wildcard $(src_dir)/common/*.c) $(wildcard $(src_dir)/common/*.S) $$(RISCV_LINK_OPTS)
endef

$(foreach bmark,$(tests),$(eval $(call compile_template,$(bmark))))

#------------------------------------------------------------
# Build and run benchmarks on riscv simulator

tests_riscv_bin  = $(addsuffix .riscv,  $(tests))
tests_riscv_dump = $(addsuffix .riscv.dump, $(tests))
tests_riscv_out  = $(addsuffix .riscv.out,  $(tests))

$(tests_riscv_dump): %.riscv.dump: %.riscv
	$(RISCV_OBJDUMP) $< > $@

$(tests_riscv_out): %.riscv.out: %.riscv
	$(RISCV_SIM) $< > $@

riscv: $(tests_riscv_dump)
run: $(tests_riscv_out)

junk += $(tests_riscv_bin) $(tests_riscv_dump) $(tests_riscv_hex) $(tests_riscv_out)

#------------------------------------------------------------
# Default

all: riscv

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(objs) $(junk)