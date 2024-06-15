#!/usr/bin/env python3

##   custdocian.py  ---  "Custodian of custom documentation".

## Description:

# This is a script I use to mainly put in .github/ to update various bits of
# documentation. It can do quite a few different things but, ironically, I
# haven't documented what it can do (yet)! This is some placeholder text in the
# meantime.

## License:

# Copyright (c) 2024 Julian Orchard <hello@julianorchard.co.uk>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

## Code:

import os
import re
import sys

DOC_FILE = ".github/README.md"
CONFIGS = [
    {
        "target": "autohotkey/",
        "match-type": "simple",
        "selector": "AHK:",
    },
    {
        "target": "scripts/",
        "selector": "Description:",
        "match-type": "block",
        "selector-end": "License:",
    },
]
COMMENT_STRINGS = ["# ", ":: ", "' ", "; "]


def print_without_comments(line: str) -> str:
    "Removes comment strings from the text."
    for commentstring in COMMENT_STRINGS:
        if commentstring in line:
            adjustment = len(commentstring) - 1
            line = line[adjustment:]
    return line.replace("\n", " ").replace("\t", " ")


def insert_target_comment(
    target_comment: str, new_content: str, doc_content: str
) -> str:
    """
    e.g. Replace the following:
    ```markdown
    <!--begin target_comment-->
    - Script 1 [link](link/to-script-1.sh)
    - Script 2 [link](link/to-script-2.sh)
    <!--end target_comment-->
    ```
    """
    start_comment = rf"\<\!--begin {target_comment}--\>"
    end_comment = rf"\<\!--end {target_comment}--\>"
    regex = re.compile(rf"({start_comment})(\n.*?)+({end_comment})", re.MULTILINE)

    # We want to escape the backslashes when putting the HTML comments back
    # into the documentation file:
    c1 = start_comment.replace("\\", "")
    c2 = end_comment.replace("\\", "")

    # And then we need to wrap the new_content in the comments so that it'll be
    # replaced next time we want to update it!
    new_content = f"{c1}\n{new_content}\n{c2}"
    return regex.sub(
        new_content,
        doc_content,
    )


def err(msg: str):
    "Error message and exit."
    print(f"ERROR: {msg}")
    sys.exit()


def get_files_list(targets: str) -> list[str]:
    "Get a list of files to run the 'docstring' type thing on."
    with os.scandir(targets) as target:
        return [
            obj.name
            for obj in target
            if obj.is_file()
            and not obj.name.startswith(".")
            and not obj.name.endswith(".md")
            and not obj.name.endswith(".txt")
        ]


def format_table(headings: list, contents: list[dict]) -> str:
    """
    Format the input list as a table!
    """

    # TODO: Would be nice to justify the table but not sure I can *justify*
    #       spending time on something so superfluous.
    #
    #       Although if I were to do it the best way would be to just find the
    #       longest part of any column and make the whitespace fill that
    #       size... not too bad but we can leave this as a thing for later...

    # Write heading
    table = ""
    c = 0
    for title in headings:
        c += 1
        table = f"{table}| {title} "
    table = f"{table} |\n"

    # Add heading splitter
    for _ in range(c):
        table = f"{table}| --- "
    table = f"{table} |\n"

    # The rest of the table content
    for content in contents:
        file = f"[{content['filename']}]({content['filepath']})"
        for part in content["content"]:
            table = f"{table}| {part} "
        table = f"{table}| {file} "
        table = f"{table} |\n"

    return table


def format_list(contents: list[dict]):
    """
    Format the inputs as a simple list with headings as the filenames and links
    to the files, etc.!
    """
    content_list = ""
    for content in contents:
        # Don't show any files with empty descriptions
        if content["content"] == "":
            continue
        content_list = f"{content_list}\n### {content['filename']}\n"
        content_list = f"{content_list}\n{content['content']}\n"
    return content_list


def simple(config: dict) -> list:
    """
    The simple setting expects comments like this:

    ```python
    # IDENTIFIER: `something`, explaination
    ```

    Mainly used for key mappings and the like!
    """
    files = get_files_list(config["target"])
    contents = []
    for file in files:
        f = open(config["target"] + file, "r")
        lines = f.readlines()
        for line in lines:
            if config["selector"] in line:
                # Get rid of the comment in the line
                line = print_without_comments(line)
                # Get rid of the selector
                keep = line.split(":")[1]
                contents_list = keep.split(",")
                # Strip the line to make it tidier
                contents_list = [c.strip() for c in contents_list]
                content_and_metadata = {
                    "filename": file,
                    "filepath": config["target"] + file,
                    "content": contents_list,
                }
                contents.append(content_and_metadata)
    return contents


def block(config: dict) -> list:
    """
    The block setting expects comments like this:

    ```python
    # Start of capture group:

    foo bar baz qux quux

    # End of capture group:
    ```

    The delims can be anything here but we're basically just reading between
    the groups and doing some .replace()ing to make it nicer.
    """
    files = get_files_list(config["target"])
    contents = []
    for file in files:
        f = open(config["target"] + file, "r")
        lines = f.readlines()
        capture = False
        content = ""
        for line in lines:
            if config["selector-end"] in line:
                # No point in even reading the file anymore
                capture = False
                break
            if capture:
                formatted_line = print_without_comments(line).strip()
                content = f"{content} {formatted_line}"
            if config["selector"] in line:
                capture = True
        contents_and_metadata = {
            "filename": file,
            "filepath": config["target"] + file,
            "content": content.strip(),
        }
        contents.append(contents_and_metadata)
    return contents


def main():
    with open(DOC_FILE) as doc:
        doc_content = doc.read()
    for config in CONFIGS:
        if config["match-type"] == "simple":
            contents = simple(config)
            headings = ["Keys", "Description", "File"]
            table = format_table(headings, contents)
            doc_content = insert_target_comment(
                target_comment="ahk_mapping",
                new_content=table,
                doc_content=doc_content,
            )
        if config["match-type"] in "block":
            # Get information between selectors
            contents = block(config)
            content_list = format_list(contents)
            doc_content = insert_target_comment(
                target_comment="scripts",
                new_content=content_list,
                doc_content=doc_content,
            )

    # print(doc_content)
    with open(DOC_FILE, "w") as doc:
        doc.write(doc_content)


if __name__ == "__main__":
    main()
