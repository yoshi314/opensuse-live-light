#!/bin/bash
mkdir -p iso

kiwi --prepare config --root root
kiwi --create root --type iso -d iso

