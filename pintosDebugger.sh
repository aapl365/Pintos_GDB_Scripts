#!/bin/bash

# Creates a new gdb wrapper with your desired settings
# by creating new gdb-macros similar to pintos

# ---------- VARIABLES ----------
PROJECT=vm/build
PROJROOT=$(find ~ -name 'OSF17project-yam')

# Absolute path to this script
SCRIPT=$(readlink -f "$0")

# Absolute path to this script's directory
SCRIPT_PATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

TESTCASE=$(cat $SCRIPT_PATH/testcase.txt)



# --------- MAIN ----------
# Start gdb for testcase
gnome-terminal --working-directory=$PROJROOT/$PROJECT -e "$TESTCASE"

# Creating new gdb-macros
cd $PROJROOT/misc
cp gdb-macros gdb-macros_personal
cat $SCRIPT_PATH/config.txt >> gdb-macros_personal

# Creating new script to execute macros in tui environment
cd $PROJROOT/utils
cp pintos-gdb pintos-gdb_personal

sed -i "s/GDB=gdb/GDB=gdbtui/g" pintos-gdb_personal
ESCAPED_ROOT=${PROJROOT//\//\\\/}

sed -i "s/GDBMACROS_DEFAULT=.*/GDBMACROS_DEFAULT=$ESCAPED_ROOT\/misc\/gdb-macros_personal/g" pintos-gdb_personal

# Attach to gdb
cd $PROJROOT/$PROJECT
pintos-gdb_personal kernel.o

# Uncomment to start debugger in new terminal
#gnome-terminal -e "pintos-gdb_personal kernel.o"

