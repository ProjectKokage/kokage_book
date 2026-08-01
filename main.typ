#import "styles.typ": *

#let book-title = "完全ローカルな話し相手の作り方"
#let book-title-display = [完全ローカルな#linebreak()話し相手の作り方]
#let book-subtitle = "言語モデル、音声、三次元キャラクターを一台の端末で動かし、会話を成り立たせる設計"
#let book-subtitle-display = [言語モデル、音声、三次元キャラクターを一台の端末で動かし、#linebreak()会話を成り立たせる設計]
#let book-author = "プロジェクトこかげ"
#let book-edition = "短縮改訂版　2026年7月27日"

#show: book.with(title: book-title)

#cover(
  title: book-title-display,
  title-note: [スマホでも動く],
  subtitle: book-subtitle-display,
  author: book-author,
  edition: book-edition,
)

#title-page(
  title: book-title-display,
  subtitle: book-subtitle-display,
  author: book-author,
  date: book-edition,
)

#include "chapters/00-prologue.typ"

#toc()

#part-page(
  number: "一",
  title: [完全ローカルの約束],
)[
  「完全ローカル」と呼べる範囲を決める。
  待ち時間とメモリの上限も、同じ約束に含める。
]

#include "chapters/01-local-promise.typ"
#include "chapters/02-experience-budget.typ"

#part-page(
  number: "二",
  title: [モデルを一台に収める],
)[
  モデル名だけでは選べない。
  端末、実行環境、補助ファイルを一組で確かめる。
]

#include "chapters/03-model-selection.typ"
#include "chapters/04-inference-optimization.typ"

#part-page(
  number: "三",
  title: [一人の相手として動かす],
)[
  文字、声、身体は別々の速さで動く。
  利用者に届く返答では、三つを一つにそろえる。
]

#include "chapters/05-turn-orchestration.typ"
#include "chapters/06-voice-loop.typ"
#include "chapters/07-vrm-performance.typ"
#include "chapters/08-blueprint.typ"
#include "chapters/09-epilogue.typ"

#counter(heading).update(0)
#set heading(numbering: "A.1")

#include "appendices/checklist.typ"
#include "appendices/glossary.typ"
#include "appendices/sources.typ"

#colophon(
  title: book-title,
  subtitle: book-subtitle,
  author: book-author,
  edition: book-edition,
  url: "https://github.com/ProjectKokage/kokage_book",
)
