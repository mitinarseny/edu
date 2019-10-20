.SECONDEXPANSION:

SOURCE_DIR ?= src
BUILD_DIR ?= build
FILTERS_DIR ?= filters

DIRS := $(shell find $(SOURCE_DIR) -type d \( ! -regex '.*/\..*' \))
MD_FILES := $(foreach d,$(DIRS),$(wildcard $(d)/*.md))
HTML_FILES := $(patsubst $(SOURCE_DIR)/%.md,$(BUILD_DIR)/%.html,$(MD_FILES))

.PHONY: all
all: html nojekyll

.PHONY: html
html: $(HTML_FILES)

$(HTML_FILES): $(BUILD_DIR)/%.html: $(SOURCE_DIR)/%.md $(FILTERS_DIR)/links_md2html.lua | $$(@D)/.f
	pandoc \
	  --standalone \
	  --from=markdown \
	  --to=html5 \
	  --lua-filter=$(FILTERS_DIR)/links_md2html.lua \
	  --katex \
	  --output=$@ \
	  $<

.PRECIOUS: %/.f
$(patsubst $(SOURCE_DIR)%,$(BUILD_DIR)%/.f,$(DIRS)): %/.f:
	@mkdir -p $(@D)

# Tell GitHub Pages not to use Jekyll
nojekyll: $(BUILD_DIR)/.nojekyll

$(BUILD_DIR)/.nojekyll: | $$(@D)/.f
	touch $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
