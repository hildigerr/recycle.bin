#!/usr/bin/awk -f

{
  line = $0;
  while (match(line, /(https?:\/\/[^"]+)/)) {
    url = substr(line, RSTART, RLENGTH);
    if (system("grep -q \"" url "\" fixed_paths.sort") != 0) {
      print "URL not found: " $0;
    }
    line = substr(line, RSTART + RLENGTH);
  }
}
