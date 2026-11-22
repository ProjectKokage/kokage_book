#import "styles.typ": *

#let book-title = "完全ローカルな対話型AIキャラクターの作り方"
#let book-title-display = [完全ローカルな対話型#linebreak()AIキャラクターの作り方]
#let book-subtitle = "LLM・音声認識・音声合成・3Dアバターをひとつのアプリに"
#let book-subtitle-display = [LLM・音声認識・音声合成・3Dアバターをひとつのアプリに]
#let book-author = "Project Kokage"
#let book-edition = "2026年8月16日"
#let print-target = sys.inputs.at("print-target", default: "book")
#let print-spine-mm = float(sys.inputs.at("spine-mm", default: "2.138"))
#let print-spine-width = print-spine-mm * 1mm
#assert(print-target in ("book", "cover", "body"), message: "print-target must be book, cover, or body")
#assert(print-spine-mm >= 0, message: "spine-mm must be zero or greater")

#show: book.with(
  title: book-title,
  page-fill: if print-target == "body" { white } else { paper },
)

#if print-target == "cover" [
  #cover-spread(
    title: book-title-display,
    title-note: [スマホで動く],
    subtitle: book-subtitle-display,
    author: book-author,
    spine: print-spine-width,
  )
] else [
  #if print-target == "book" [
    #cover(
      title: book-title-display,
      title-note: [スマホで動く],
      subtitle: book-subtitle-display,
      author: book-author,
    )
  ]

  #title-page(
    title: book-title-display,
    subtitle: book-subtitle-display,
    author: book-author,
  )

  #if print-target == "body" [
    #print-blank-page()
  ]

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
    printer: [株式会社栄光],
    url: "https://github.com/ProjectKokage/kokage_book",
    continuous-url: "https://github.com/ProjectKokage/kokage_book/releases/download/continuous/kokage_book.pdf",
    versioned-url: "https://github.com/ProjectKokage/kokage_book/releases/latest/download/kokage_book.pdf",
    x-account: "moon_kokage",
    contact: "contact@kokage.moe",
  )
]
