SRC_DIR := src
OUT_DIR := out
SRC_FILES := $(wildcard $(SRC_DIR)/*.perk)
OUT_FILES := $(OUT_DIR)/main.c
NON_PERK_FILES := $(filter-out %.perk, $(notdir $(wildcard $(SRC_DIR)/*)))
OUT_FILES += $(addprefix $(OUT_DIR)/, $(NON_PERK_FILES))
MELLOS_DIR := /home/perkelo/projects/other/MellOs
PERK_FLAGS := "--static"
C_COMPILER := "/usr/local/i386elfgcc/bin/i386-elf-gcc"
C_FLAGS := "-ffreestanding -m32 -fno-builtin -fno-stack-protector -fno-pic -Wno-error -DVGA_VESA -DHRES=600 -DVRES=400 -DBPP=4 -DWINDOW_DRAG_NORMAL -I $(MELLOS_DIR)"

.PHONY: all clean run $(OUT_DIR)/main.c

all: $(OUT_DIR)/sperkaster

$(OUT_DIR)/main.c: $(SRC_DIR)/main.perk | $(OUT_DIR)
	perkc $(PERK_FLAGS) --c-compiler $(C_COMPILER) --cflags=$(C_FLAGS) $< -o $@

# Copy non-.perk files from src to out
$(OUT_DIR)/%.h: $(SRC_DIR)/%.h | $(OUT_DIR)
	cp $< $@
	sed -i 's|$(MELLOS_DIR)|../../..|g' $@

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

clean:
	rm -rf $(OUT_DIR)

$(OUT_DIR)/sperkaster: $(OUT_FILES)
	mkdir -p $(MELLOS_DIR)/shell/functions/sperkaster
	cp -r $(OUT_DIR)/* $(MELLOS_DIR)/shell/functions/sperkaster/
	cd $(MELLOS_DIR)/build && cmake .. && make

run: $(OUT_DIR)/sperkaster
	cd $(MELLOS_DIR)/build && make run