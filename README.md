# Recycle Bin

This repository contains various scripts created for limited purposes, such as one-time tasks or quick experiments. Instead of deleting these scripts after use, they are stored here for potential future reference or reuse.

The `recycle.sh` script is a tool for moving files into this "recycle bin" repository.

It is designed to preserve temporary or one-time-use files, such as scripts or other resources, that may have value later. This repository also serves as a historical record of recycled items, allowing me (or others) to "dig through the trash" for useful code or inspiration.

## Features

- **File Recycling**: Moves specified files into a designated recycle bin directory.
- **Git Integration**: Tracks recycled files using Git, enabling version history and commit messages.
- **Customizable Commit Messages**: Specify custom commit messages or use automatically generated ones.
- **Cross-Workstation Compatibility**: Clone this repository to any workstation and link the `recycle` script into your `PATH` for seamless integration.
- **Public Sharing**: Make your recycle bin public, allowing others to "dig through your trash" at their own risk.
- **Private Branches**: Specify an alternate branch for recycling stuff you don't want to share.

## Configuration

- **RECYCLE_BIN_DIR**: Environment variable to specify the recycle bin directory. Defaults to `$HOME/.local/share/recycle.bin` if not set.

## Repository Structure

- **Main Branch**: Used for development of the `recycle` program itself (e.g., updates to the script, README, or manpage).
- **Other Branches**: Other branches can be used to represent the recycle bin for a specific user or workstation.

## Public Sharing Philosophy

This repository is public by design. Other users are welcome to:

1. Fork this repository and create their own branches for their personal recycling needs.
2. Add this repository as an upstream remote to sync my branches and "dig through my trash" at their own risk. (See Recommended Installation method below).

## Installation

### Simplest Method:

1. Save the `recycle.sh` script to a file, for example, `recycle`.
2. Make the script executable:

    ```
    chmod +x recycle
    ```

3. (Optional) Place or link the script in a directory in your `PATH` for easy access from any location (see Personal Method step 2).

### Personal Method:

1. Clone this repository into `$HOME/.local/share/`, or if cloned into an alternate location:

    ```
    export RECYCLE_BIN_DIR="/wherever/you/want/idc"
    ```

2. Run `make install` to create links to the `recycle.sh` script and manpage. This is essentially equivalent to:

    ```
    ln --symbolic -T $RECYCLE_BIN_DIR/recycle.sh $HOME/.local/bin/recycle
    ln --symbolic -T $RECYCLE_BIN_DIR/recycle.1 $HOME/.local/man/man1/recycle.1
    ```

3. If `$HOME/.local/bin` is not in your `PATH`, you can add it in your shell configuration file:

    ```
    export PATH="$HOME/.local/bin:$PATH"
    ```

4. If `$HOME/.local/man` is not in your `MANPATH`, you can add it in your shell configuration file:

    ```
    export MANPATH="$HOME/.local/man:$MANPATH"
    ```

5. Initialize the recycle bin directory by creating a personal branch:

    ```
    recycle -b=$USER
    ```

### Recommended Method:

1. Fork this repository and set it up with your own branch as in the personal method above.
2. (Optional) Add this repository as an upstream remote to enable syncing my branches.

    ```
    git remote add upstream https://github.com/hildigerr/recycle.bin.git
    git fetch upstream
    ```

3. "Dig through my trash" at your own risk:

    ```
    git checkout hildigerr
    git pull upstream hildigerr
    ```

4. (Optional) Keep items from my trash in your own branch:

    ```
    git checkout $USER
    git cherry-pick <hash>
    ```

5. (Optional) Remove my branch:

    ```
    git branch -d hildigerr
    ```

6. Push your own trash to sync across workstations and/or share with others.

7. Recycle stuff to a private branch and don't share it with others.

    ```
    recycle -b=private /potentially/sensitive/or/othewise/not/for/others.file
    ```

## Usage

### Basic Command

recycle [options] <file1> <file2> ...

### Options

- `-m "message"`: Specify a custom commit message. If not provided, a default message including the date, time, and original file paths will be used.

### Examples

1. Recycle a single file:

    ```
    recycle /path/to/file.txt
    ```

2. Recycle multiple files with a custom commit message:

    ```
    recycle -m "scraped example.com" /path/to/scrape_example.sh /path/to/post_process_example.sh
    ```

3. Recycle multiple files with the default commit message:

    ```
    recycle /path/to/file1.txt /path/to/file2.txt
    ```

4. Initialize a new personal branch:

    ```
    recycle -b=$USER
    ```

5. Recycle files into a new branch:

    ```
    recycle -b=new_branch /path/to/oldfile1.txt /path/to/oldfile2.txt
    ```

## Default Commit Message Format

```
[YYYY-MM-DD-HHmm.ss]

/original/file/path/of/first/input.file
...
/original/file/path/of/last/input.file
```

Where:
- `YYYY-MM-DD` is the year, month, and day.
- `HHmm.ss` is the hour (24-hour format), minutes, and seconds.
- `/original/file/path/input.file` is the full path of the file being moved.
- The list of files is always included in the commit message body.

## Error Handling

- **Non-existent recycle.bin directory**: Creates the directory and initializes a Git repository within it.
- **Non-existent files**: The script will output a warning message and skip moving non-existent files.
- **No input files**: If no files are provided, the script will display an error message and exit.

## Licensing

### Script License

The `recycle.sh` script is licensed under the [Artistic License 2.0](https://opensource.org/licenses/Artistic-2.0).

### Recycled Items

All recycled items stored in this repository are considered **public domain**, unless explicitly stated otherwise in their content.

## Author

Hildigerr Vergaray

