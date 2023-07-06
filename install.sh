#!/usr/bin/env bash

#
# Copyright (C) 2023 Christoph Sommer <sommer@cms-labs.org>
#
# Documentation for these modules is at http://veins.car2x.org/
#
# SPDX-License-Identifier: GPL-2.0-or-later
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

set -e

# set TARGET_DIR to ../veins if not set
TARGET_DIR=${TARGET_DIR:-../veins}

# ensure that TARGET_DIR contains an installation of Veins
if [ ! -f "$TARGET_DIR"/src/veins/veins.h ]; then
    echo >&2 "Could not find \"$TARGET_DIR/src/veins/veins.h\". Please set TARGET_DIR to the root of your Veins installation. Aborting."
    exit 1
fi

# set SOURCE_DIR to .devcontainer
SOURCE_DIR=.devcontainer

# ensure that SOURCE_DIR directory does not exist yet in TARGET_DIR
if [ -d "$TARGET_DIR"/"$SOURCE_DIR" ]; then
    echo >&2 "Found \"$TARGET_DIR/$SOURCE_DIR\". Please remove it before installing. Aborting."
    exit 1
fi

# create SOURCE_DIR directory in TARGET_DIR
echo "Creating \"$TARGET_DIR/$SOURCE_DIR/\""
mkdir "$TARGET_DIR"/"$SOURCE_DIR"

# create .gitignore file in TARGET_DIR/SOURCE_DIR
echo "Creating \"$TARGET_DIR/$SOURCE_DIR/.gitignore\""
echo ".gitignore" >>"$TARGET_DIR"/"$SOURCE_DIR"/.gitignore

# loop over all files in SOURCE_DIR directory and
# - create hard links in TARGET_DIR
# - add the file name to the .gitignore file in TARGET_DIR/SOURCE_DIR
for file in "$SOURCE_DIR"/*; do

    # ensure that file is a regular file
    if [ ! -f "$file" ]; then
        echo >&2 "Skipping \"$file\" because it is not a regular file"
        continue
    fi

    echo "Creating hard link \"$TARGET_DIR/$file\" -> \"$file\""
    ln "$file" "$TARGET_DIR"/"$SOURCE_DIR"

    echo "Adding \"$file\" to \"$TARGET_DIR/$SOURCE_DIR/.gitignore\""
    echo "$(basename "$file")" >>"$TARGET_DIR"/"$SOURCE_DIR"/.gitignore
done
