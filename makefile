CXX := g++

# Colors
COLOR_BLACK   := "\033[1;30m"
COLOR_RED     := "\033[1;31m"
COLOR_GREEN   := "\033[1;32m"
COLOR_YELLOW  := "\033[1;33m"
COLOR_BLUE    := "\033[1;34m"
COLOR_MAGENTA := "\033[1;35m"
COLOR_CYAN    := "\033[1;36m"
COLOR_WHITE   := "\033[1;37m"
COLOR_END     := "\033[0m"

ARG_WARNING := -Wall -Wextra -Wpedantic
ARG_INCLUDE := -Idependencies/include -Isrc/RailEditor
ARG_DEBUG   := -g -O0
ARG_RELEASE := -O3 -flto -fwhole-program
ARG_LINK    := -Ldependencies/lib64 -lSDL2 -lGL -lGLEW

DEBUG_ARGS    = $(ARG_WARNING) $(ARG_DEBUG)
RELEASE_ARGS  = $(ARG_WARNING) $(ARG_RELEASE)
ARGS = $(DEBUG_ARGS)

MODULE_LIST   := . graphics
MODULE_OUTPUT_DEBUG := $(addprefix obj/debug/RailEditor/, $(MODULE_LIST))
MODULE_OUTPUT_RELEASE := $(addprefix obj/release/RailEditor/, $(MODULE_LIST))
SRC_LIST         := $(foreach mod,$(MODULE_LIST),$(wildcard src/RailEditor/$(mod)/*.cpp))
OBJ_LIST_DEBUG   := $(patsubst src/%.cpp,obj/debug/%.o,$(SRC_LIST))
OBJ_LIST_RELEASE := $(patsubst src/%.cpp,obj/release/%.o,$(SRC_LIST))

PROGRAM_NAME := RailEditor

DEBUG_FOLDER := bin_debug
RELEASE_FOLDER := bin_release

.PHONY: debug release clean

debug: $(MODULE_OUTPUT_DEBUG)
debug: $(DEBUG_FOLDER)/$(PROGRAM_NAME)

release: ARGS = $(RELEASE_ARGS)
release: $(MODULE_OUTPUT_RELEASE)
release: $(RELEASE_FOLDER)/$(PROGRAM_NAME)

obj/debug/%.o: src/%.cpp
	@echo $(COLOR_WHITE)$(CXX)$(COLOR_BLUE) $^$(COLOR_END)
	@$(CXX) $< $(ARG_WARNING) $(ARGS) $(ARG_INCLUDE) -c -o $@

obj/release/%.o: src/%.cpp
	@echo $(COLOR_WHITE)$(CXX)$(COLOR_BLUE) $^$(COLOR_END)
	@$(CXX) $< $(ARG_WARNING) $(ARGS) $(ARG_INCLUDE) -c -o $@

$(DEBUG_FOLDER)/$(PROGRAM_NAME): $(OBJ_LIST_DEBUG) | bin_debug
	@echo $(COLOR_WHITE)Linking$(COLOR_GREEN) $@$(COLOR_END)
	@$(CXX) $^ $(ARG_WARNING) $(ARGS) $(ARG_LINK) -o $@

$(RELEASE_FOLDER)/$(PROGRAM_NAME): $(OBJ_LIST_RELEASE) | bin_release
	@echo $(COLOR_WHITE)Linking and Optimizing$(COLOR_GREEN) $@$(COLOR_END)
	@$(CXX) $^ $(ARG_WARNING) $(ARGS) $(ARG_LINK) -o $@

define make-obj-dirs
$1:
	@echo $(COLOR_WHITE)Making obj directory$(COLOR_MAGENTA) $$@$(COLOR_END)
	@mkdir -p $$@
endef

bin_debug bin_release:
	@echo $(COLOR_WHITE)Making binary directory$(COLOR_CYAN) $@$(COLOR_END)
	@mkdir -p $@

$(foreach mods,$(MODULE_OUTPUT_DEBUG) $(MODULE_OUTPUT_RELEASE),$(eval $(call make-obj-dirs,$(mods))))

clean:
	rm -rf obj bin_debug/ bin_release/