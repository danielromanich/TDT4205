# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.9

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /cygdrive/c/Users/Daniel-ASUS/.CLion2017.3/system/cygwin_cmake/bin/cmake.exe

# The command to remove a file.
RM = /cygdrive/c/Users/Daniel-ASUS/.CLion2017.3/system/cygwin_cmake/bin/cmake.exe -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/MyExec.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/MyExec.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/MyExec.dir/flags.make

CMakeFiles/MyExec.dir/pencil.c.o: CMakeFiles/MyExec.dir/flags.make
CMakeFiles/MyExec.dir/pencil.c.o: ../pencil.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/MyExec.dir/pencil.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/MyExec.dir/pencil.c.o   -c /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/pencil.c

CMakeFiles/MyExec.dir/pencil.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/MyExec.dir/pencil.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/pencil.c > CMakeFiles/MyExec.dir/pencil.c.i

CMakeFiles/MyExec.dir/pencil.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/MyExec.dir/pencil.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/pencil.c -o CMakeFiles/MyExec.dir/pencil.c.s

CMakeFiles/MyExec.dir/pencil.c.o.requires:

.PHONY : CMakeFiles/MyExec.dir/pencil.c.o.requires

CMakeFiles/MyExec.dir/pencil.c.o.provides: CMakeFiles/MyExec.dir/pencil.c.o.requires
	$(MAKE) -f CMakeFiles/MyExec.dir/build.make CMakeFiles/MyExec.dir/pencil.c.o.provides.build
.PHONY : CMakeFiles/MyExec.dir/pencil.c.o.provides

CMakeFiles/MyExec.dir/pencil.c.o.provides.build: CMakeFiles/MyExec.dir/pencil.c.o


CMakeFiles/MyExec.dir/scanner.c.o: CMakeFiles/MyExec.dir/flags.make
CMakeFiles/MyExec.dir/scanner.c.o: ../scanner.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/MyExec.dir/scanner.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/MyExec.dir/scanner.c.o   -c /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/scanner.c

CMakeFiles/MyExec.dir/scanner.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/MyExec.dir/scanner.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/scanner.c > CMakeFiles/MyExec.dir/scanner.c.i

CMakeFiles/MyExec.dir/scanner.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/MyExec.dir/scanner.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/scanner.c -o CMakeFiles/MyExec.dir/scanner.c.s

CMakeFiles/MyExec.dir/scanner.c.o.requires:

.PHONY : CMakeFiles/MyExec.dir/scanner.c.o.requires

CMakeFiles/MyExec.dir/scanner.c.o.provides: CMakeFiles/MyExec.dir/scanner.c.o.requires
	$(MAKE) -f CMakeFiles/MyExec.dir/build.make CMakeFiles/MyExec.dir/scanner.c.o.provides.build
.PHONY : CMakeFiles/MyExec.dir/scanner.c.o.provides

CMakeFiles/MyExec.dir/scanner.c.o.provides.build: CMakeFiles/MyExec.dir/scanner.c.o


# Object files for target MyExec
MyExec_OBJECTS = \
"CMakeFiles/MyExec.dir/pencil.c.o" \
"CMakeFiles/MyExec.dir/scanner.c.o"

# External object files for target MyExec
MyExec_EXTERNAL_OBJECTS =

MyExec.exe: CMakeFiles/MyExec.dir/pencil.c.o
MyExec.exe: CMakeFiles/MyExec.dir/scanner.c.o
MyExec.exe: CMakeFiles/MyExec.dir/build.make
MyExec.exe: CMakeFiles/MyExec.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking C executable MyExec.exe"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/MyExec.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/MyExec.dir/build: MyExec.exe

.PHONY : CMakeFiles/MyExec.dir/build

CMakeFiles/MyExec.dir/requires: CMakeFiles/MyExec.dir/pencil.c.o.requires
CMakeFiles/MyExec.dir/requires: CMakeFiles/MyExec.dir/scanner.c.o.requires

.PHONY : CMakeFiles/MyExec.dir/requires

CMakeFiles/MyExec.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/MyExec.dir/cmake_clean.cmake
.PHONY : CMakeFiles/MyExec.dir/clean

CMakeFiles/MyExec.dir/depend:
	cd /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/cmake-build-debug /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/cmake-build-debug /cygdrive/f/Skole/Fag/TDT4205/PS1/aliens/cmake-build-debug/CMakeFiles/MyExec.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/MyExec.dir/depend
