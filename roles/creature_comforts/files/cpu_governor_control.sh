#!/bin/bash

# --- Configuration ---
# File path for available governors (used for checking)
AVAILABLE_GOVERNORS_FILE="/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors"

## --- Function 1: Display Help Menu ---

help_menu() {
  echo ""
  echo "📜 **CPU Governor Control Script**"
  echo "-------------------------------------"
  echo "This script allows you to view the current CPU governor settings and change them."
  echo ""
  echo "**USAGE:**"
  echo "  1. **View Status:** ./cpu_governor_control.sh"
  echo "  2. **Set Governor:** sudo ./cpu_governor_control.sh <NEW_GOVERNOR>"
  echo "  3. **Show Help:** ./cpu_governor_control.sh -h | --help"
  echo ""
  echo "**GOVERNOR OPTIONS:**"
  if [ -f "$AVAILABLE_GOVERNORS_FILE" ]; then
    available_governors=$(cat "$AVAILABLE_GOVERNORS_FILE")
    echo "  Available governors usually include: **$available_governors**"
  else
    echo "  Common options are: performance, powersave, ondemand, conservative, schedutil."
  fi
  echo ""
  echo "**NOTE:** Changing the governor requires **sudo** (root) permissions."
  echo "-------------------------------------"
  echo ""
  exit 0
}

## --- Function 2: Display Current Governor and Available Governors ---

show_governor_info() {
  echo "--- CPU Governor Status ---"

  # Show Current Governor Per Core
  echo "👉 **Current CPU Governor Per Core**"
  echo "-------------------------------------"

  local found_governors=0
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    core_num=$(basename $(dirname $(dirname "$cpu")) | sed 's/cpu//')
    if [ -f "$cpu" ]; then
      governor=$(cat "$cpu")
      echo "Core $core_num: **$governor**"
      found_governors=1
    fi
  done

  if [ $found_governors -eq 0 ]; then
    echo "Could not find any CPU governor files. Your system may not be using the standard 'cpufreq' interface."
  fi

  echo ""

  # Show Available CPU Governors
  echo "📋 **Available CPU Governors (System-wide)**"
  echo "-------------------------------------------"

  if [ -f "$AVAILABLE_GOVERNORS_FILE" ]; then
    available_governors=$(cat "$AVAILABLE_GOVERNORS_FILE")
    echo "Valid options: **$available_governors**"
  else
    echo "Could not find available governors list."
  fi
  echo "---------------------------"
}

## --- Function 3: Change the CPU Governor ---

change_governor() {
  local NEW_GOVERNOR="$1"

  # Check for root permissions
  if [ "$EUID" -ne 0 ]; then
    echo "❌ **ERROR:** You must run this script with **sudo** to change the governor."
    help_menu
  fi

  # Check if a governor name was provided (should be caught in main logic, but good redundancy)
  if [ -z "$NEW_GOVERNOR" ]; then
    echo "❌ **ERROR:** Please provide the name of the governor to set."
    help_menu
  fi

  local SUCCESS_COUNT=0
  local TOTAL_CORES=0

  echo "⚙️ Attempting to set governor for all cores to: **$NEW_GOVERNOR**"

  # Iterate through all CPU cores and set the new governor
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    TOTAL_CORES=$((TOTAL_CORES + 1))
    core_num=$(basename $(dirname $(dirname "$cpu")) | sed 's/cpu//')

    if [ -f "$cpu" ]; then
      if echo "$NEW_GOVERNOR" >"$cpu" 2>/dev/null; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
      else
        echo "Warning: Failed to set governor for Core $core_num. (Is '$NEW_GOVERNOR' a valid option?)"
      fi
    fi
  done

  echo ""
  if [ $TOTAL_CORES -gt 0 ]; then
    if [ $SUCCESS_COUNT -eq $TOTAL_CORES ]; then
      echo "✅ **SUCCESS:** Successfully set governor to **$NEW_GOVERNOR** on all $TOTAL_CORES cores."
    else
      echo "⚠️ **PARTIAL SUCCESS/FAILURE:** Successfully changed governor on $SUCCESS_COUNT out of $TOTAL_CORES cores."
    fi
  else
    echo "❌ **ERROR:** No CPU scaling_governor files found."
  fi
}

## --- Main Script Execution ---

# Check for help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  help_menu
fi

# Check if an argument was passed (a new governor name)
if [ -n "$1" ]; then
  change_governor "$1"
else
  # If no argument, just show the status
  show_governor_info
fi
