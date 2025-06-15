# ide-chat-prettier - AIエディタのチャットを見やすくする

## 紹介

ide-chat-prettier を使うと、AIエディタのチャットをエクスポートした内容を見やすくしてくれます。
Visual Studio Code の Copilot、Cursor に対応しています。

具体的に、ユーザとAIの一回の対話を details summary でまとめてくれます。
これによってとても長く続くチャットセッション

## インストール方法

ダウンロードしたファイルに実行権限を付与してパスの通ったディレクトリにいれるだけです。
例えば `/usr/local/bin` にパスが通っている場合は、ダウンロードした ide-chat-prettier に対して

```shell-script
$ chmod +x ide-chat-prettier 
$ sudo cp ide-chat-prettier /usr/local/bin/
```

で行えます。 `/usr/local/bin` のような root のみ書き込みが許可されているディレクトリの場合は sudo の使用と、
sudo のパスワードを適宜用いて下さい。

動作環境は perl 5.10 以上です。例えば 2025年現在の各種 Linux 環境の場合、これを満たさない環境はごく稀でしょう。

## 利用方法

引数なしで実行するとヘルプが出てきます。

```
ide-chat-prettier
```

必須引数は、チャットを保存したファイルです。チャットを保存したファイルを第1引数に指定すると、
出力として details summary で各会話ペアを囲んだ内容が出力されます。

```
ide-chat-prettier cursor_export.md
```

結果を保存したい場合はファイルリダイレクト `>` を使うか、第2引数に保存したいファイル名を書きます。

VSCode の場合、ユーザ側の会話の始まりの行が GitHubユーザ名とコロンの連結となっているので、GitHub ユーザ名を指定する必要があります。

```
ide-chat-prettier --github-user xtetsuji vscode_export.md
```

もしシステムに gh コマンドが入っていてログインが通っている場合は、それを使って GitHub アカウントを割り出せるため
引数は省略できます。

```
ide-chat-prettier vscode_export.md
```

## AIチャットの内容のエクスポート方法

### VScode の場合

チャットウィンドウの中のなにもない箇所をクリックすると出るメニューから「すべてコピー」を選択すると
クリップボードに格納されます。

なお、macOS の場合は pbpaste コマンドでクリップボードの内容が出力されるので、
出力内容を一時的にファイルとみなす bash zsh のプロセス置換 `<(...)` を使うことで

```
ide-chat-prettier <(pbpaste)
```

とすることで変換結果を得ることもできます。

pbpaste の逆であるコピーを行う pbcopy コマンドと組み合わせて

```
ide-chat-prettier <(pbpaste) | pbcopy
```

とすることで、クリップボードの内容を変換後のものに置き換えることもできます（冪等ではないので重複実行に注意）。

### Cursor の場合

チャットウィンドウの一番上のメニューバーの `...` メニューから Export Chat を選択するとファイルとして出力できます。

## ライセンス

MIT

Author: OGATA Tetsuji @xtetsuji