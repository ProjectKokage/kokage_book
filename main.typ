#import "styles.typ": *

#let book-title = "完全ローカルな話し相手の作り方"
#let book-title-display = [完全ローカルな#linebreak()話し相手の作り方]
#let book-subtitle = "言語モデル、音声、3Dキャラクターを一台の端末でつなぐ設計"
#let book-subtitle-display = [言語モデル、音声、3Dキャラクターを一台の端末でつなぐ設計]
#let book-author = "Project Kokage"
#let book-edition = "2026年8月16日"

#show: book.with(title: book-title)

#cover(
  title: book-title-display,
  title-note: [スマホでも動く],
  subtitle: book-subtitle-display,
  author: book-author,
)

#title-page(
  title: book-title-display,
  subtitle: book-subtitle-display,
  author: book-author,
)

#include "chapters/00-prologue.typ"

#toc()

#include "chapters/01-llm.typ"
#include "chapters/02-voice.typ"
#include "chapters/03-character.typ"
#include "chapters/04-integration.typ"
#include "chapters/05-epilogue.typ"

#counter(heading).update(0)
#set heading(numbering: "A.1")

#include "appendices/checklist.typ"
#include "appendices/glossary.typ"
#include "appendices/control-vocab.typ"
#include "appendices/sources.typ"

#colophon(
  title: book-title,
  subtitle: book-subtitle,
  author: book-author,
  edition: book-edition,
  // 入稿先が決まったら実名に差し替える
  printer: [(未定)],
  url: "https://github.com/ProjectKokage/kokage_book",
  x-account: "moon_kokage",
)
