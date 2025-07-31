#!/bin/bash

# Default values
start=1
time=2
n=30
x=800
y=90

# Process command-line arguments using getopt
options=$(getopt --long "start:,time:,n:,x:,y:" -o "s:t:n:x:y:" -- "$@")

# Check for errors
if [ $? -ne 0 ]; then
  echo "Usage: $0 [--start value] [--time value] [--n value] [--x value] [--y value]" >&2
  exit 1
fi

# Assign the processed options to the script's arguments
eval set -- "$options"

# Parse the options
while true; do
  case "$1" in
    --start) start="$2"; shift 2 ;;
    --time)  time="$2"; shift 2 ;;
    -n)      n="$2"; shift 2 ;;
    -x)      x="$2"; shift 2 ;;
    -y)      y="$2"; shift 2 ;;
    --)      shift; break ;;
    *)       echo "Internal error!" ; exit 1 ;;
  esac
done

# Display the values (for demonstration)
echo "start = $start"
echo "time = $time"
echo "n = $n"
echo "x = $x"
echo "y = $y"

