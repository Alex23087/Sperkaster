SRC_DIR := src
OUT_DIR := out
SRC_FILES := $(wildcard $(SRC_DIR)/*.perk)
OUT_FILES := $(OUT_DIR)/main.c
NON_PERK_FILES := $(filter-out %.perk, $(notdir $(wildcard $(SRC_DIR)/*)))
OUT_FILES += $(addprefix $(OUT_DIR)/, $(NON_PERK_FILES))
MELLOS_DIR := /home/perkelo/projects/other/MellOs

.PHONY: all clean run $(OUT_DIR)/main.c

all: $(OUT_DIR)/perkeng

$(OUT_DIR)/main.c: $(SRC_DIR)/main.perk | $(OUT_DIR)
	perkc --static $< -o $@

# Copy non-.perk files from src to out
$(OUT_DIR)/%.h: $(SRC_DIR)/%.h | $(OUT_DIR)
	cp $< $@
	sed -i 's|$(MELLOS_DIR)|../../..|g' $@

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

clean:
	rm -rf $(OUT_DIR)

$(OUT_DIR)/perkeng: $(OUT_FILES)
	mkdir -p $(MELLOS_DIR)/shell/functions/perkeng
	cp -r $(OUT_DIR)/* $(MELLOS_DIR)/shell/functions/perkeng/
	cd $(MELLOS_DIR)/build && cmake .. && make

run: $(OUT_DIR)/perkeng
	cd $(MELLOS_DIR)/build && make run