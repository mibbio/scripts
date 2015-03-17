#!/bin/bash
lspci -nn | grep "VGA" | grep -o -E "[[:alnum:]]{4}:[[:alnum:]]{4}" | sed 's/:/ /g'
