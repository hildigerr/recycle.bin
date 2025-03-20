#!/usr/bin/expect -f

#exp_internal 1

# Set the directory to search
set directory "."

# Set the subdirectory to check for
#set subordinate_dir "./Unsorted/"
set subordinate_dir "./Holiday/"

# Spawn the Python script
spawn python3 find_duplicates.py $directory

# Expect loop to handle duplicate prompts
expect {
    -re {Duplicates found with hash: [0-9a-fA-F]+\r\n} {
        puts "Found duplicate block"
        # Extract the file paths
        expect -re {1. [^\r\n]*\r\n}
        set file1 $expect_out(0,string)
        puts "File 1: $file1"
        expect -re {2. [^\r\n]*\r\n}
        set file2 $expect_out(0,string)
        puts "File 2: $file2"
        expect "Enter command (keep n, delete n, remove n, move path), or press Enter to skip: "
        puts "Found prompt"

        # Check if either file is within the subordinate directory
        if {[string first $subordinate_dir $file1] != -1} {
            send "delete 1\r"
            puts "Deleted file 1"
        } elseif {[string first $subordinate_dir $file2] != -1} {
            send "delete 2\r"
            puts "Deleted file 2"
        } else {
            # No automatic deletion, just send enter to skip
            send "\r"
            puts "Skipped"
        }
        exp_continue
    }
    "Duplicate search complete." {
        puts "Search complete"
        # End of script
        exit 0
    }
    timeout {
        puts "Timeout occurred"
        exit 1
    }
    eof {
        puts "Unexpected end of file"
        exit 1
    }
}
