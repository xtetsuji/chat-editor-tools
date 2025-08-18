#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

# デフォルト設定
my $max_lines = 100;
my $replace_mode = 0;
my $backup_suffix = '.bak';
my $omission_message = '# ... (省略: %d行) ...';
my $help = 0;

GetOptions(
    'max-lines|m=i' => \$max_lines,
    'replace|r' => \$replace_mode,
    'backup-suffix|b=s' => \$backup_suffix,
    'omission-message|o=s' => \$omission_message,
    'help|h' => \$help,
) or pod2usage(2);

# ヘルプ表示
if ($help) {
    pod2usage(-exitval => 0, -verbose => 1);
}

# 入力ファイルを指定しなければ STDIN から読む
@ARGV = ('-') unless @ARGV;

if ($replace_mode) {
    # 置換モード：ファイルを実際に書き換える
    process_files_replace_mode();
} else {
    # 検知モード：従来の動作
    process_files_detect_mode();
}

sub process_files_detect_mode {
    # 状態管理用変数
    my $in_block    = 0;   # コードブロック内かどうか
    my $start_file  = '';  # ブロック開始ファイル名
    my $start_line  = 0;   # ブロック開始行番号
    my $line_count  = 0;   # ブロック内行数

    for my $file (@ARGV) {
        open my $fh, '<', $file or die "Cannot open '$file': $!\n";
        my $lineno = 0;
        while (my $line = <$fh>) {
            $lineno++;
            # コードブロックの開始・終了を検知（``` のみを行頭に）
            if ($line =~ /^```/) {
                if (!$in_block) {
                    # ブロック開始
                    $in_block   = 1;
                    $start_file = $file;
                    $start_line = $lineno;
                    $line_count = 0;
                } else {
                    # ブロック終了
                    if ($line_count > $max_lines) {
                      printf STDERR "%s:%d: Large code block detected (%d lines from %d to %d)\n",
                      $start_file, $start_line, $line_count, $start_line, $lineno;
                    }
                    $in_block = 0;
                }
                next;
            }

            # ブロック内なら行数をカウント
            $line_count++ if $in_block;
        }
        close $fh;
    }
}

sub process_files_replace_mode {
    for my $file (@ARGV) {
        next if $file eq '-';  # STDINは置換モードでは対応しない
        
        # ファイル全体を読み込み
        open my $fh, '<', $file or die "Cannot open '$file': $!\n";
        my @lines = <$fh>;
        close $fh;
        
        my $modified = 0;
        my @new_lines;
        my $in_block = 0;
        my $block_start_idx = 0;
        my $block_lines = [];
        my $block_lang = '';
        
        for my $i (0 .. $#lines) {
            my $line = $lines[$i];
            
            if ($line =~ /^```(.*)$/) {
                if (!$in_block) {
                    # ブロック開始
                    $in_block = 1;
                    $block_start_idx = $i;
                    $block_lines = [];
                    $block_lang = $1;  # 言語指定を保持
                    push @new_lines, $line;
                } else {
                    # ブロック終了
                    if (scalar @$block_lines > $max_lines) {
                        # 長大なブロックを省略メッセージに置き換え
                        my $omitted_count = scalar @$block_lines;
                        my $msg = sprintf($omission_message, $omitted_count);
                        push @new_lines, $msg . "\n";
                        $modified = 1;
                        printf STDERR "%s: Replaced large code block (%d lines) with omission message\n", $file, $omitted_count;
                    } else {
                        # 通常サイズのブロックはそのまま出力
                        push @new_lines, @$block_lines;
                    }
                    push @new_lines, $line;
                    $in_block = 0;
                }
            } elsif ($in_block) {
                # ブロック内の行を記録
                push @$block_lines, $line;
            } else {
                # ブロック外の行はそのまま
                push @new_lines, $line;
            }
        }
        
        # ファイルが変更されていれば書き戻し
        if ($modified) {
            # バックアップを作成
            if ($backup_suffix) {
                my $backup_file = $file . $backup_suffix;
                open my $backup_fh, '>', $backup_file or die "Cannot create backup '$backup_file': $!\n";
                print $backup_fh @lines;
                close $backup_fh;
                printf STDERR "%s: Backup created as %s\n", $file, $backup_file;
            }
            
            # 新しい内容で上書き
            open my $out_fh, '>', $file or die "Cannot write to '$file': $!\n";
            print $out_fh @new_lines;
            close $out_fh;
            printf STDERR "%s: File updated\n", $file;
        }
    }
}

__END__

=pod

=head1 NAME

detect_code_blocks.pl - 三つバッククォートで囲まれた長大なコードブロックを検知・省略

=head1 SYNOPSIS

  detect_code_blocks.pl [OPTIONS] [file...]

  # デフォルト閾値（100行）でファイルをチェック
  detect_code_blocks.pl document.md

  # 閾値を50行に変更して検知
  detect_code_blocks.pl --max-lines 50 document.md

  # 長大なコードブロックを省略メッセージに置き換え
  detect_code_blocks.pl --replace --max-lines 80 document.md

  # カスタム省略メッセージとバックアップ拡張子を指定
  detect_code_blocks.pl --replace \
      --omission-message "# コード省略(%d行)" \
      --backup-suffix .orig document.md

  # 複数ファイルまとめて処理
  detect_code_blocks.pl --replace --max-lines 30 *.md

  # ヘルプ表示
  detect_code_blocks.pl --help

=head1 DESCRIPTION

Markdown 文書などに含まれる

    ```（バッククォート三つ）
    （コード行1）
    （コード行2）
    ...
    ```（バッククォート三つ）

という形式の「コードブロック」を検出し、その中の行数が指定した閾値を超えていれば警告メッセージを標準エラー出力に出します。

C<--replace> オプションを指定すると、長大なコードブロックを省略メッセージに実際に置き換えます。

=head1 OPTIONS

=over 4

=item B<--max-lines, -m> I<行数>

コードブロックとしてカウントする最大行数を指定します。デフォルトは100行です。

=item B<--replace, -r>

置換モードを有効にします。長大なコードブロックを省略メッセージに実際に置き換えます。

=item B<--backup-suffix, -b> I<拡張子>

置換モード時に作成するバックアップファイルの拡張子を指定します。デフォルトは '.bak' です。空文字列を指定するとバックアップを作成しません。

=item B<--omission-message, -o> I<メッセージ>

省略時に表示するメッセージのテンプレートを指定します。%d は省略された行数に置き換えられます。デフォルトは '# ... (省略: %d行) ...' です。

=item B<--help, -h>

ヘルプメッセージを表示して終了します。

=back

=cut
