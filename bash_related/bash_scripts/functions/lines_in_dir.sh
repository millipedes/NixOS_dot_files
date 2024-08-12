lines_in_dir() {
  find $1 -type f -exec wc -l {} + | awk '{total += $1} END {print total}'
}
