.PHONY: all clean

TARGET ?= target
PROFILE ?= debug
PLATFORM := $(shell clang --version | sed -rn 's/Target: (.*)/\1/p')

OUT := $(TARGET)/$(PROFILE)/$(PLATFORM)

all: $(OUT)/rt
clean:
	@-rm -r $(OUT)

ifneq ($(findstring $(MAKEFLAGS),s),s)
	ECHO_CC   = @echo '   ' C $(@:$(OUT)/%=%);
endif

CC_FLAGS.debug := -g -DDEBUG
CC_FLAGS.release := -O3
CC_FLAGS = $(CC_FLAGS.$(PROFILE)) $(CC_FLAGS.$(PLATFORM)) $(CC_FLAGS.$(PROFILE).$(PLATFORM)) -I src/. -std=c11

rt := main
$(OUT)/rt: $(rt:%=src/rt/%.c) | $(OUT)/
	$(ECHO_CC)$(CC) $(CC_FLAGS) -o $@ $^

$(OUT)/:
	@mkdir -p $@

