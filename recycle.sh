#!/bin/bash

# Default recycle bin directory
RECYCLE_BIN_DIR="${RECYCLE_BIN_DIR:-$HOME/.local/share/recycle.bin}"

# Default commit message head line
COMMIT_MESSAGE="[$(date +"%Y-%m-%d-%H%M.%S")]"

# Silence pushd and popd
pushd () {
  command pushd "$@" > /dev/null
}
popd () {
  command popd "$@" > /dev/null
}

# Check if RECYCLE_BIN_DIR exists, if not create it and initialize git
if [ ! -d "$RECYCLE_BIN_DIR" ]; then
  mkdir -p "$RECYCLE_BIN_DIR"
  pushd "$RECYCLE_BIN_DIR" || exit 1
  git init
  popd
fi

branch() {
  BRANCH=$1
  pushd "$RECYCLE_BIN_DIR"
  git checkout "$BRANCH" 2>/dev/null || \
  git checkout -b "$BRANCH" master || exit 1
  popd 
}

cherry_pick() {
  HASH=$1
  pushd "$RECYCLE_BIN_DIR"
  git cherry-pick $HASH || exit 1
  popd 
}

# Parse arguments
FILES=()
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --branch|-b) branch "$2"; shift ;;
    --branch=*|-b=*) branch "${1#*=}" ;;
    --cherry-pick|--copy|-cp) cherry_pick "$2"; shift ;;
    --cherry-pick=*|--copy=*|-cp=*) cherry_pick "${1#*=}" ;;
    --list|-ls) pushd "$RECYCLE_BIN_DIR" && ls && popd ;;
    --llist|-ll) pushd "$RECYCLE_BIN_DIR" && ls -l && popd ;;
    --log) pushd "$RECYCLE_BIN_DIR" || exit 1
      git log --all --oneline --decorate --graph
      popd ;;
    --message|-m) COMMIT_MESSAGE="$2"; shift ;;
    --message=*|-m=*) COMMIT_MESSAGE="${1#*=}" ;;
    *) if [ -e "$1" ]; then FILES+=("$1")
       else echo "Warning: File '$1' does not exist. Skipping."
       fi ;;
  esac
  shift
done

# Check if valid files are provided
if [ ${#FILES[@]} -eq 0 ]; then
  echo "Warning: Nothing to recycle. Done."
  exit
fi

# Move files to the recycle bin directory
for FILE in "${FILES[@]}"; do
  mv "$FILE" "$RECYCLE_BIN_DIR"
done

# Stage and commit changes with git
cd "$RECYCLE_BIN_DIR" || exit 1
git add .
git commit -m "$COMMIT_MESSAGE" -m "$(printf "/%s\n" "${FILES[@]}")"

