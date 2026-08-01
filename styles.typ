#let ink = rgb("#1f2933")
#let muted = rgb("#66737d")
#let accent = rgb("#1f746d")
#let accent-dark = rgb("#15544f")
#let warm = rgb("#c96d3b")
#let paper = rgb("#fcfbf7")
#let pale = rgb("#edf6f3")
#let pale-warm = rgb("#fbf0e9")
#let rule = rgb("#ccd8d4")

#let body-font = "Hiragino Mincho ProN"

#let sans-font = "Hiragino Sans"

#let mono-font = "Menlo"

// 木陰の葉。表紙のキャラクターと同じ葉を、扉・中扉・奥付の目印に使う。
#let leaf-mark = box(width: 9mm, height: 13.5mm, {
  place(top + left, curve(
    stroke: (paint: accent, thickness: 1pt, cap: "round"),
    curve.move((8.2mm, 12.9mm)),
    curve.quad((6mm, 9.8mm), (4.2mm, 7.2mm)),
  ))
  place(top + left, curve(
    fill: accent,
    curve.move((4.7mm, 7.6mm)),
    curve.cubic((5.8mm, 3.8mm), (3.6mm, 1.2mm), (0.4mm, 0.6mm)),
    curve.cubic((0.2mm, 3.6mm), (1.8mm, 6.6mm), (4.7mm, 7.6mm)),
    curve.close(),
  ))
})

// 見出しの番号ラベル(第1章 / 付録A / 序章・終章)を柱と目次で共用する。
#let heading-label(ev, styled: true) = {
  if ev.numbering == "A.1" {
    [付録#numbering("A", counter(heading).at(ev.location()).first())]
  } else if ev.numbering != none {
    [第#counter(heading).at(ev.location()).first()章]
  } else if ev.supplement not in (none, auto) {
    ev.supplement
  } else {
    none
  }
}

#let book(title: "", body) = {
  set document(title: title)
  set page(
    paper: "a5",
    fill: paper,
    margin: (
      top: 18mm,
      bottom: 19mm,
      inside: 20mm,
      outside: 16mm,
    ),
    header-ascent: 7mm,
    footer-descent: 8mm,
    header: context {
      let page-number = counter(page).get().first()
      let is-blank = query(metadata.where(value: "blank-page")).any(event =>
        counter(page).at(event.location()).first() == page-number
      )
      if page-number > 3 and not is-blank {
        let chapter-events = query(
          heading.where(level: 1).or(
            metadata.where(value: "chapter-header-reset"),
          ),
        )
        let current-chapter-events = chapter-events.filter(event =>
          counter(page).at(event.location()).first() <= page-number
        )
        if current-chapter-events.len() > 0 {
          let current-chapter = current-chapter-events.last()
          let chapter-start-page = counter(page).at(current-chapter.location()).first()
          if current-chapter.func() == heading and chapter-start-page < page-number {
            set text(font: sans-font, size: 6.7pt, fill: muted, tracking: 0.04em)
            if calc.even(page-number) {
              align(left)[#title]
            } else {
              let label = heading-label(current-chapter)
              align(right)[
                #if label != none [#text(fill: accent, weight: 600)[#label]#h(7pt)]
                #current-chapter.body
              ]
            }
          }
        }
      }
    },
    footer: context {
      let page-number = counter(page).get().first()
      let is-blank = query(metadata.where(value: "blank-page")).any(event =>
        counter(page).at(event.location()).first() == page-number
      )
      if page-number > 2 and not is-blank {
        set text(font: sans-font, size: 7pt, fill: muted)
        align(center)[#counter(page).display("1")]
      }
    },
    numbering: "1",
  )

  set text(
    font: body-font,
    size: 9.2pt,
    fill: ink,
    lang: "ja",
    region: "JP",
  )
  set par(
    justify: true,
    leading: 0.78em,
    spacing: 0.78em,
    first-line-indent: (amount: 1em, all: true),
  )
  set heading(numbering: "1.1")
  set list(
    indent: 1.1em,
    body-indent: 0.55em,
    spacing: 0.5em,
    marker: (text(fill: accent)[•], text(fill: muted, size: 0.85em)[◦]),
  )
  set enum(indent: 1.1em, body-indent: 0.55em, spacing: 0.5em)
  set table(
    stroke: 0.45pt + rule,
    inset: (x: 5pt, y: 4pt),
  )
  show raw: set text(font: mono-font, size: 7.7pt)

  // 原稿は一文一行で書くため、行末が約物のときに入る欧文スペースを取り除く。
  // 改行そのもの(#linebreak())は対象にせず、スペースだけを詰める。
  show regex("[。、!?」』)] "): it => it.text.trim()
  // 約物が連続するとき(。「 や 」。など)は、間の空きを半角分に詰める。
  show regex("[。、」』)] ?[「『(。、]"): it => {
    let chars = it.text.replace(" ", "").clusters()
    box[#chars.at(0)#h(-0.5em)#chars.at(1)]
  }

  show link: set text(fill: accent-dark)
  show emph: set text(fill: accent-dark)
  show strong: set text(font: sans-font, fill: accent-dark)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    block(
      above: 0pt,
      below: 20pt,
      breakable: false,
    )[
      #context {
        let eyebrow = heading-label(it)
        if eyebrow != none {
          grid(
            columns: (auto, 1fr),
            column-gutter: 10pt,
            align: horizon,
            text(font: sans-font, size: 8pt, weight: 600, fill: accent, tracking: 0.16em)[#eyebrow],
            line(length: 100%, stroke: 0.5pt + rule),
          )
        }
      }
      #v(10pt)
      #text(font: sans-font, size: 21pt, weight: 700, fill: ink)[#it.body]
      #v(9pt)
      #line(length: 30mm, stroke: 1.8pt + accent)
    ]
  }

  show heading.where(level: 2): it => {
    block(
      above: 16pt,
      below: 7pt,
      breakable: false,
    )[
      #set par(justify: false, first-line-indent: 0em)
      #if it.numbering != none {
        context text(font: sans-font, size: 9pt, weight: 700, fill: accent)[#counter(heading).display(it.numbering)]
        h(8pt)
      }
      #text(font: sans-font, size: 13pt, weight: 700, fill: ink)[#it.body]
    ]
  }

  show heading.where(level: 3): it => {
    block(
      above: 11pt,
      below: 4pt,
      breakable: false,
    )[
      #text(font: sans-font, size: 10.3pt, weight: 700, fill: accent-dark)[#it.body]
    ]
  }

  show quote: it => block(
    inset: (left: 10pt, right: 8pt, top: 7pt, bottom: 7pt),
    stroke: (left: 2pt + accent),
    fill: pale,
    radius: (right: 3pt),
  )[
    #set par(first-line-indent: 0em)
    #it.body
  ]

  body
}

// 目次。部の区切りと章・節を、部の中扉と見出しの位置から組み立てる。
#let toc() = {
  pagebreak(weak: true)
  metadata("chapter-header-reset")
  block(below: 18pt, breakable: false)[
    #text(font: sans-font, size: 21pt, weight: 700, fill: ink)[目次]
    #v(9pt)
    #line(length: 30mm, stroke: 1.8pt + accent)
  ]
  set text(font: sans-font)
  set par(justify: false, leading: 0.5em, spacing: 0.5em, first-line-indent: 0em)
  context {
    let events = query(heading.where(outlined: true).or(metadata))
    for ev in events {
      if ev.func() == metadata {
        if type(ev.value) == dictionary and ev.value.at("kind", default: "") == "part" {
          v(9pt)
          block(below: 4pt)[
            #link(ev.location())[
              #text(size: 7.6pt, weight: 600, fill: accent, tracking: 0.14em)[第#(ev.value.number)部]
              #h(9pt)
              #text(size: 10.5pt, weight: 700, fill: ink)[#ev.value.title]
              #box(width: 1fr)
              #text(size: 8pt, fill: muted)[#counter(page).at(ev.location()).first()]
            ]
          ]
          line(length: 100%, stroke: 0.5pt + rule)
          v(3pt)
        }
      } else if ev.level == 1 {
        let page-no = counter(page).at(ev.location()).first()
        block(above: 6pt, below: 4pt)[
          #link(ev.location())[
            #box(width: 27pt, text(size: 7.3pt, weight: 600, fill: accent)[#heading-label(ev)])
            #text(size: 9.4pt, weight: 600, fill: ink)[#ev.body]
            #box(width: 1fr)
            #text(size: 8.4pt, weight: 600, fill: ink)[#page-no]
          ]
        ]
      } else if ev.level == 2 {
        let page-no = counter(page).at(ev.location()).first()
        block(above: 2.6pt, below: 2.6pt)[
          #link(ev.location())[
            #h(27pt)
            #box(width: 22pt, text(size: 7.6pt, fill: muted)[#numbering(ev.numbering, ..counter(heading).at(ev.location()))])
            #text(size: 8.6pt, fill: ink)[#ev.body]
            #box(width: 1fr, align(right, box(inset: (x: 4pt), text(size: 7.6pt, fill: rule.darken(15%))[#repeat([.], gap: 3.2pt)])))
            #text(size: 8pt, fill: muted)[#page-no]
          ]
        ]
      }
    }
  }
}

// 表紙。図版を置かず、文字組と余白だけで構成する。
#let cover(
  title: "",
  title-note: none,
  subtitle: "",
  author: "",
  edition: "",
) = page(margin: 0mm, fill: paper, header: none, footer: none)[
  #set text(font: sans-font, fill: ink)

  // タイトル
  #place(top + left, dx: 18mm, dy: 47mm,
    line(length: 12mm, stroke: 2.4pt + accent))
  #place(top + left, dx: 18mm, dy: 53mm, {
    set par(leading: 0.42em)
    text(size: 31pt, weight: 800)[#title]
  })

  // サブタイトル
  #place(top + left, dx: 18mm, dy: 86mm, {
    set par(leading: 0.8em)
    text(size: 9.3pt, weight: 500, fill: rgb("#3d4852"))[#subtitle]
  })

  // ひとこと(帯の代わりのラベル)
  #if title-note != none {
    place(top + left, dx: 18mm, dy: 100.5mm,
      box(fill: warm, inset: (x: 3.2mm, y: 2mm), radius: 0.8mm,
        text(size: 10pt, weight: 700, fill: paper, tracking: 0.08em)[#title-note]))
  }

  // 地の書誌情報
  #place(top + left, dx: 18mm, dy: 172mm, scale(66%, reflow: true, leaf-mark))
  #place(top + left, dx: 18mm, dy: 185mm,
    text(size: 9.5pt, weight: 600)[#author])
  #place(top + left, dx: 18mm, dy: 191.5mm,
    text(size: 7pt, weight: 400, fill: muted)[#edition])
]

#let title-page(title: "", subtitle: "", author: "", date: "") = {
  page(header: none, footer: none)[
    #align(center + horizon)[
      #scale(66%, reflow: true, leaf-mark)
      #v(10pt)
      #text(font: body-font, size: 20pt, weight: 600, fill: ink)[#title]
      #v(13pt)
      #text(font: sans-font, size: 9.5pt, fill: accent-dark)[#subtitle]
      #v(30pt)
      #text(font: sans-font, size: 9pt, fill: ink)[#author]
      #v(4pt)
      #text(font: sans-font, size: 7.8pt, fill: muted)[#date]
    ]
  ]
}

#let part-page(number: "", title: "", body) = {
  // 中扉は右ページ(奇数)に置く。手前に空白ページが入る場合は目印がそこに残り、
  // 柱とノンブルを刷らない。
  pagebreak(weak: true)
  metadata("blank-page")
  pagebreak(weak: true, to: "odd")
  page(header: none, footer: none)[
    #metadata("chapter-header-reset")
    #metadata((kind: "part", number: number, title: title))
    #align(center + horizon)[
      #block(width: 88%)[
        #text(font: sans-font, size: 8.5pt, weight: 600, fill: accent, tracking: 0.3em)[第#(number)部]
        #v(10pt)
        #text(font: sans-font, size: 24pt, weight: 700, fill: ink)[#title]
        #v(12pt)
        #line(length: 24mm, stroke: 1.8pt + warm)
        #v(16pt)
        #block(width: 78%)[
          #set text(font: body-font, size: 9.2pt, fill: muted)
          #set par(first-line-indent: 0em, justify: false, leading: 0.85em)
          #body
        ]
      ]
    ]
  ]
}

// 奥付。書誌情報と利用条件を最終ページ下部にまとめる。
#let colophon(
  title: "",
  subtitle: "",
  author: "",
  edition: "",
  url: "",
) = {
  page(header: none, footer: none)[
    #align(bottom)[
      #set text(font: sans-font)
      #set par(first-line-indent: 0em, justify: false, leading: 0.6em)
      #leaf-mark
      #v(6pt)
      #line(length: 100%, stroke: 0.6pt + rule)
      #v(13pt)
      #text(size: 11pt, weight: 700, fill: ink)[#title]
      #v(4pt)
      #text(size: 7.6pt, fill: muted)[#subtitle]
      #v(14pt)
      #grid(
        columns: (58pt, 1fr),
        row-gutter: 7pt,
        ..(
          ([発行], [#edition]),
          ([著者], [#author]),
          ([組版], [Typst 0.15 (ヒラギノ明朝 ProN・ヒラギノ角ゴシック・Menlo)]),
          ([配布], [#link(url)[#url]]),
          ([利用条件], [CC BY-NC-SA 4.0 (表示・非営利・継承)]),
        ).map(((label, value)) => (
          text(size: 7.4pt, weight: 600, fill: muted, tracking: 0.08em)[#label],
          text(size: 8pt, fill: ink)[#value],
        )).flatten()
      )
      #v(16pt)
      #text(size: 7.2pt, fill: muted)[© 2026 プロジェクトこかげ]
    ]
  ]
}

#let chapter-lead(body) = block(
  below: 14pt,
)[
  #set text(size: 10.2pt, fill: accent-dark)
  #set par(first-line-indent: 0em, leading: 0.82em)
  #body
]

#let key-point(title: [設計の要点], body) = block(
  above: 10pt,
  below: 10pt,
  inset: 10pt,
  fill: pale,
  stroke: 0.7pt + rule,
  radius: 4pt,
  breakable: true,
)[
  #set par(first-line-indent: 0em)
  #text(font: sans-font, size: 8.4pt, weight: 700, fill: accent-dark)[#title]
  #v(4pt)
  #body
]

#let caution(title: [判断を誤りやすい点], body) = block(
  above: 10pt,
  below: 10pt,
  inset: 10pt,
  fill: pale-warm,
  stroke: 0.7pt + rgb("#e6c7b4"),
  radius: 4pt,
  breakable: false,
)[
  #set par(first-line-indent: 0em)
  #text(font: sans-font, size: 8.4pt, weight: 700, fill: warm)[#title]
  #v(4pt)
  #body
]

#let case-study(title: [こかげでの確認], body) = block(
  above: 10pt,
  below: 10pt,
  inset: (left: 10pt, right: 10pt, top: 8pt, bottom: 8pt),
  stroke: (left: 2.5pt + accent),
  breakable: true,
)[
  #set par(first-line-indent: 0em)
  #text(font: sans-font, size: 8.2pt, weight: 700, fill: accent-dark)[#title]
  #v(3pt)
  #set text(size: 8.4pt)
  #body
]

#let figure-panel(caption: none, body) = figure(
  placement: auto,
  block(
    width: 100%,
    inset: 9pt,
    fill: rgb("#f5f7f5"),
    stroke: 0.6pt + rule,
    radius: 4pt,
  )[
    #set par(first-line-indent: 0em)
    #body
  ],
  caption: if caption == none { none } else {
    text(font: sans-font, size: 7.8pt, fill: muted)[#caption]
  },
)

#let flow-node(body, fill-color: pale) = block(
  width: 100%,
  inset: (x: 6pt, y: 5pt),
  fill: fill-color,
  stroke: 0.6pt + rule,
  radius: 3pt,
)[
  #align(center)[
    #set text(font: sans-font, size: 8pt)
    #body
  ]
]

#let flow-arrow = text(font: sans-font, size: 9pt, fill: accent)[↓]

#let source-link(label, url) = link(url)[#label]
