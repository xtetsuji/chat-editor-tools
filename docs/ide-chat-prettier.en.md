# ide-chat-prettier - Make AI Editor Chat More Readable

## Introduction

ide-chat-prettier makes exported AI editor chat content more readable.
It supports Visual Studio Code Copilot and Cursor.

Specifically, it wraps each user-AI conversation pair with details summary elements.
This allows you to paste extremely long chat sessions into GitHub Issues or Pull Requests in a readable format.

## Installation

Simply add execute permission to the downloaded file and place it in a directory in your PATH.
For example, if `/usr/local/bin` is in your PATH, you can install the downloaded ide-chat-prettier with:

```shell-script
chmod +x ide-chat-prettier 
```

```shell-script
sudo cp ide-chat-prettier /usr/local/bin/
```

For directories like `/usr/local/bin` that require root write permissions, use sudo and
enter your sudo password as needed.

The runtime requirement is Perl 5.10 or later. For example, in most Linux and macOS environments as of 2025, 
environments that don't meet this requirement are extremely rare.
It doesn't use any external modules and runs standalone.

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

To use ide-chat-prettier, you first need to export the AI editor chat content to a file.

ide-chat-prettier automatically detects whether the chat format is from VSCode Copilot or Cursor and processes it appropriately.

### For VSCode

Click on an empty area in the chat window and select "Copy All" from the context menu.
This will copy the content to your clipboard.

On macOS, since the pbpaste command outputs clipboard content, you can save the clipboard content to a file:

```
pbpaste > vscode_chat_export.md
```

Then process it with:

```
ide-chat-prettier vscode_chat_export.md
```

You can combine it with pbcopy to replace clipboard content with the converted version:

```
ide-chat-prettier vscode_chat_export.md | pbcopy
```

### For Cursor

Select "Export Chat" from the `...` menu in the top menu bar of the chat window to export as a file.

The rest is the same as the VSCode case above.

```
ide-chat-prettier cursor_export.md
```

```
ide-chat-prettier cursor_export.md | pbcopy
```

## License

MIT

Author: OGATA Tetsuji @xtetsuji
