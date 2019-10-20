.SECONDEXPANSION:

SOURCE_PATH ?= src
BUILD_PATH ?= build
FILTERS_PATH ?= filters

DIRS := $(shell find $(SOURCE_PATH) -type d \( ! -regex '.*/\..*' \))
MD_FILES := $(foreach d,$(DIRS),$(wildcard $(d)/*.md))
HTML_FILES := $(patsubst $(SOURCE_PATH)/%.md,$(BUILD_PATH)/%.html,$(MD_FILES))

.PHONY: all
all: html nojekyll

.PHONY: html
html: $(HTML_FILES)

$(HTML_FILES): $(BUILD_PATH)/%.html: $(SOURCE_PATH)/%.md $(FILTERS_PATH)/links_md2html.lua | $$(@D)/.f
	pandoc \
	  --standalone \
	  --from=markdown \
	  --to=html5 \
	  --lua-filter=$(FILTERS_PATH)/links_md2html.lua \
	  --katex \
	  --output=$@ \
	  $<

.PRECIOUS: %/.f
$(patsubst $(SOURCE_PATH)%,$(BUILD_PATH)%/.f,$(DIRS)): %/.f:
	@mkdir -p $(@D)

# Tell GitHub Pages not to use Jekyll
nojekyll: $(BUILD_PATH)/.nojekyll

$(BUILD_PATH)/.nojekyll: | $$(@D)/.f
	touch $@

.PHONY: clean
clean:
	rm -rf $(BUILD_PATH)
