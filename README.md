# 完全ローカルな対話型AIキャラクターの作り方

Typst で組版した日本語技術書の原稿です。

こかげの設計資料を下敷きに、LLM、音声認識、音声合成、3Dアバターをひとつのアプリにつなぐ設計を、実装コードへ踏み込まない粒度で整理しています。

`draft.md` は初期メモとして残しています。
主要な論点は本編へ取り込み済みです。

## 組版

Typst 0.15 以降を想定しています。

```sh
mkdir -p output/pdf
typst compile main.typ output/pdf/kokage_book.pdf
sh scripts/build-print.sh 2.138
```

通常版の PDF は188 × 263 mmです。
中央の182 × 257 mmを JIS B5 の仕上がり枠とし、四辺に3mmの塗り足しを設けています。

`scripts/build-print.sh` は、栄光への入稿用として次の2ファイルを `output/pdf/eikou/` に生成します。

- `cover.pdf`：左から表4、背、表1を並べたカラー見開き表紙。外周3mmの塗り足しを含む。
- `001-028.pdf`：表紙を含まない28ページのグレースケール本文。1ページ目は扉、2ページ目は白紙。

引数は背幅のmm値です。
例の `2.138` は、スターアートボード19.5kg、上質90kg、総32ページの場合の栄光の計算値です。
注文した用紙または栄光の見開き表紙生成ツールが示す背幅へ置き換えてください。
入稿用データは PDF タグを無効にしています。
本文のグレースケール変換には Ghostscript を使います。

日本語本文にはヒラギノ明朝、見出しにはヒラギノ角ゴシックを使います。
別環境では `styles.typ` の `body-font` と `sans-font` を、導入済みの日本語フォント名へ変更してください。

## GitHub Releases への公開

`.github/workflows/publish-book.yml` は、プルリクエスト、`main` ブランチへの push、手動実行で PDF を組版し、14 日間保存する Actions artifact として登録します。

`main` への push が成功すると、`continuous` pre-release の PDF も同じファイル名で置き換えます。
これは各コミット時点の確認用であり、次の固定 URL から取得できます。

```text
https://github.com/ProjectKokage/kokage_book/releases/download/continuous/kokage_book.pdf
```

`v` で始まるタグを push すると、同じ PDF をそのタグの GitHub Release に添付します。
ハイフンを含まないタグは Latest に設定し、`v1.0.0-rc.1` のようにハイフンを含むタグは pre-release として公開して Latest の対象外にします。

```sh
git tag -a v1.0.1 -m "v1.0.1"
git push origin v1.0.1
```

最新の正式版 PDF は、次の URL で取得できます。

```text
https://github.com/ProjectKokage/kokage_book/releases/latest/download/kokage_book.pdf
```

特定の版は、タグを含む固定 URL で取得できます。

```text
https://github.com/ProjectKokage/kokage_book/releases/download/v1.0.1/kokage_book.pdf
```

誌面を手元の組版結果と揃えるため、ワークフローは Typst 0.15.1 と `macos-15` を使います。
必要なヒラギノ書体と Menlo が存在しない場合、公開前に失敗します。

## ライセンス

© 2026 Project Kokage

本リポジトリの内容は、[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/) のもとで公開します。
完全な条文は [`LICENSE.txt`](LICENSE.txt) を参照してください。

## 構成

- `main.typ`：書籍全体の構成と書誌情報
- `styles.typ`：JIS B5 判（仕上がり 182 × 257 mm、四辺の塗り足し 3 mm）の組版、見出し、コラム、図版の定義
- `chapters/`：序章、全 4 章、終章の本文
- `appendices/`：設計チェックリスト、用語集、制御記法の語彙、参考資料
- `output/pdf/`：組版済みの文書

著者名と発行日は `main.typ` 冒頭で変更できます。
