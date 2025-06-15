# ide-chat-prettier - Make AI Editor Chat More Readable

## Introduction

ide-chat-prettier makes exported AI editor chat content more readable.
It supports Visual Studio Code Copilot and Cursor.

Specifically, it wraps each user-AI conversation pair with details summary elements.
This makes extremely long chat sessions much easier to read and navigate.

## Installation

Simply add execute permission to the downloaded file and place it in a directory in your PATH.
For example, if `/usr/local/bin` is in your PATH, you can install the downloaded ide-chat-prettier with:

```shell-script
$ chmod +x ide-chat-prettier 
$ sudo cp ide-chat-prettier /usr/local/bin/
```

For directories like `/usr/local/bin` that require root write permissions, use sudo and
enter your sudo password as needed.

The runtime requirement is Perl 5.10 or later. For example, in most Linux environments as of 2025, 
environments that don't meet this requirement are extremely rare.

## Usage

Running without arguments displays help:

```
ide-chat-prettier
```

The required argument is the file containing the saved chat. Specify the chat file as the first argument,
and the output will be formatted with details summary wrapping each conversation pair.

```
ide-chat-prettier cursor_export.md
```

To save the results, use file redirection `>` or specify the output filename as the second argument.

For VSCode, since user conversation lines start with GitHub username followed by a colon, 
you need to specify your GitHub username:

```
ide-chat-prettier --github-user xtetsuji vscode_export.md
```

If you have the gh command installed and logged in on your system, it can automatically detect 
your GitHub account, so the argument can be omitted:

```
ide-chat-prettier vscode_export.md
```

## How to Export AI Chat Content

### For VSCode

Click on an empty area in the chat window and select "Copy All" from the context menu.
This will copy the content to your clipboard.

On macOS, since the pbpaste command outputs clipboard content, you can use bash/zsh process substitution `<(...)` 
to treat the output as a temporary file:

```
ide-chat-prettier <(pbpaste)
```

This allows you to get the conversion results directly.

You can combine it with pbcopy (the reverse of pbpaste) to replace clipboard content with the converted version:

```
ide-chat-prettier <(pbpaste) | pbcopy
```

This replaces the clipboard content with the converted version (note: not idempotent, so be careful about repeated execution).

### For Cursor

Select "Export Chat" from the `...` menu in the top menu bar of the chat window to export as a file.

## License

MIT

Author: OGATA Tetsuji @xtetsuji
