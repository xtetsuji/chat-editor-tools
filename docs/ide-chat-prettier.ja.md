# ide-chat-prettier - AIエディタのチャットを見やすくする

## 紹介

ide-chat-prettier を使うと、AIエディタのチャットをエクスポートした内容を見やすくしてくれます。
Visual Studio Code の Copilot、Cursor に対応しています。

具体的に、ユーザとAIの一回の対話を details summary でまとめてくれます。
これによって、とても長く続くチャットセッションを GitHub の Issue や Pull-rqueest に見やすい形で貼り付けることができます。

## インストール方法

ダウンロードしたファイルに実行権限を付与してパスの通ったディレクトリにいれるだけです。
例えば `/usr/local/bin` にパスが通っている場合は、ダウンロードした ide-chat-prettier に対して

```shell-script
chmod +x ide-chat-prettier 
```

```shell-script
sudo cp ide-chat-prettier /usr/local/bin/
```

で行えます。 `/usr/local/bin` のような root のみ書き込みが許可されているディレクトリの場合は sudo の使用と、
sudo のパスワードを適宜用いて下さい。

動作環境は perl 5.10 以上です。例えば 2025年現在の各種 Linux および macOS 環境の場合、これを満たさない環境はごく稀でしょう。
外部モジュールも使っておらず、単体で動きます。

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

ide-chat-prettier を使うためには、まず AI エディタのチャット内容をファイルにエクスポートする必要があります。

ide-chat-prettier は、チャットのフォーマットから VSCode の Copilot と Cursor のチャットのどちらかを見分けて適切に処理が行われます。

### VScode の場合

チャットウィンドウの中のなにもない箇所をクリックすると出るメニューから「すべてコピー」を選択すると
クリップボードに格納されます。

なお、macOS の場合は pbpaste コマンドでクリップボードの内容が出力されるので、

```
pbpaste > vscode_chat_export.md
```

としてクリップボード中の内容をファイルに書き出しておいて、

```
ide-chat-prettier vscode_chat_export.md
```

とすることで変換結果を得ることもできます。

pbpaste の逆である、コピーを行う pbcopy コマンドと組み合わせて

```
ide-chat-prettier vscode_chat_export.md | pbcopy
```

とすることで、クリップボードの内容を変換後のものに置き換えることもできます。

### Cursor の場合

チャットウィンドウの一番上のメニューバーの `...` メニューから Export Chat を選択するとファイルとして出力できます。

あとは、上記 VSCode の場合と同様です。

```
ide-chat-prettier cursor_export.md
```

```
ide-chat-prettier cursor_export.md | pbcopy
```

## ライセンス

MIT

Author: OGATA Tetsuji @xtetsuji
