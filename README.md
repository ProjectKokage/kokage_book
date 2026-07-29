# 完全ローカルな話し相手の作り方

Typst で組版した日本語技術書の原稿です。

Kokage の設計資料を下敷きに、モデル選定、端末内推論の高速化、音声、三次元キャラクターの制御を、実装コードへ踏み込みすぎない粒度で整理しています。

`draft.md` は初期メモとして残しています。
主要な論点は本編へ取り込み済みです。

## 組版

Typst 0.15 以降を想定しています。

```sh
typst compile main.typ output/pdf/kokage_book.pdf
```

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

© 2026 Kokage プロジェクト

本リポジトリの内容は、[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/) のもとで公開します。
完全な条文は [`LICENSE.txt`](LICENSE.txt) を参照してください。

## 構成

- `main.typ`：書籍全体の構成と書誌情報
- `styles.typ`：A5 判の組版、見出し、コラム、図版の定義
- `chapters/`：序章、全 8 章、終章の本文
- `appendices/`：設計チェックリスト、用語集、参考資料
- `output/pdf/`：組版済みの文書

著者名、版表記、発行日は `main.typ` 冒頭で変更できます。
