# 完全ローカルな話し相手の作り方

Typst で組版した日本語技術書の原稿です。

Kokage の設計資料を下敷きに、モデル選定、端末内推論の高速化、三次元キャラクターの制御を中心とした設計知識を、実装コードへ踏み込まず短くまとめています。

既存の `draft.md` は初期メモとして残し、その論点を本編へ取り込みました。

## 組版

Typst 0.15 以降を想定しています。

```sh
typst compile main.typ output/pdf/kokage_book.pdf
```

日本語本文にはヒラギノ明朝、見出しにはヒラギノ角ゴシックを使います。
別環境では `styles.typ` の `body-font` と `sans-font` を、導入済みの日本語フォントへ変更してください。

## GitHub Releases への公開

`.github/workflows/publish-book.yml` は、プルリクエスト、`main` ブランチへの push、手動実行で PDF を組版し、14 日間保存する Actions artifact として登録します。

`v` で始まるタグを push すると、同じ PDF をそのタグの GitHub Release に添付します。
ハイフンを含まないタグは Latest に設定し、`v1.0.0-rc.1` のようにハイフンを含むタグは pre-release として公開して Latest の対象外にします。

```sh
git tag -a v1.0.1 -m "v1.0.1"
git push origin v1.0.1
```

最新版の PDF には、次の安定した URL でアクセスできます。

```text
https://github.com/ProjectKokage/kokage_book/releases/latest/download/kokage_book.pdf
```

各版には、タグを含む固定 URL でもアクセスできます。

```text
https://github.com/ProjectKokage/kokage_book/releases/download/v1.0.1/kokage_book.pdf
```

組版環境を現在の誌面と揃えるため、Action は Typst 0.15.1 と `macos-15` を使い、必要なヒラギノ書体と Menlo が存在しない場合は公開前に失敗します。

## ライセンス

© 2026 Kokage プロジェクト

本リポジトリの内容は、[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/) のもとで公開します。
完全な条文は [`LICENSE.txt`](LICENSE.txt) を参照してください。

## 構成

- `main.typ`：書籍全体の構成と書誌情報
- `styles.typ`：A5 判の組版、見出し、コラム、図版の定義
- `chapters/`：序章、全8章、終章の本文
- `appendices/`：設計チェックリスト、用語集、参考資料
- `output/pdf/`：組版済みの文書

著者名、版表記、発行日は `main.typ` 冒頭で変更できます。
