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
      if page-number > 3 {
        set text(font: sans-font, size: 6.8pt, fill: muted)
        align(left)[#smallcaps(title)]
      }
    },
    footer: context {
      let page-number = counter(page).get().first()
      if page-number > 2 {
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
    leading: 0.74em,
    spacing: 0.92em,
    first-line-indent: 1em,
  )
  set heading(numbering: "1.1")
  set list(indent: 1.1em, body-indent: 0.55em, spacing: 0.42em)
  set enum(indent: 1.1em, body-indent: 0.55em, spacing: 0.42em)
  set table(
    stroke: 0.45pt + rule,
    inset: (x: 5pt, y: 4pt),
  )
  show raw: set text(font: mono-font, size: 7.7pt)

  show link: set text(fill: accent-dark)
  show emph: set text(fill: accent-dark)
  show strong: set text(font: sans-font, fill: accent-dark)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    block(
      above: 0pt,
      below: 18pt,
      breakable: false,
    )[
      #context {
        set text(font: sans-font, size: 7.5pt, fill: accent, tracking: 0.08em)
        if it.numbering == none {
          it.supplement
        } else if it.numbering == "A.1" {
          let chapter-number = counter(heading).display(it.numbering)
          [付録 #chapter-number]
        } else {
          let chapter-number = counter(heading).display(it.numbering)
          [第 #chapter-number 章]
        }
      }
      #v(5pt)
      #text(font: sans-font, size: 21pt, weight: 700, fill: ink)[#it.body]
      #v(8pt)
      #line(length: 28mm, stroke: 1.6pt + accent)
    ]
  }

  show heading.where(level: 2): it => {
    block(
      above: 16pt,
      below: 7pt,
      breakable: false,
    )[
      #grid(
        columns: (3pt, 1fr),
        column-gutter: 8pt,
        rect(width: 3pt, height: 1.35em, fill: accent, radius: 1.5pt),
        text(font: sans-font, size: 13pt, weight: 700, fill: ink)[#it.body],
      )
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

#let cover(title: "", subtitle: "", author: "", edition: "") = {
  pagebreak(weak: true)
  align(center + horizon)[
    #block(width: 100%)[
      #line(length: 18mm, stroke: 2.4pt + accent)
      #v(14pt)
      #text(font: sans-font, size: 27pt, weight: 800, fill: ink)[#title]
      #v(13pt)
      #text(font: sans-font, size: 11pt, fill: accent-dark)[#subtitle]
      #v(30pt)
      #grid(
        columns: (1fr, 1fr, 1fr),
        gutter: 6pt,
        rect(height: 4pt, fill: pale, radius: 2pt),
        rect(height: 4pt, fill: accent, radius: 2pt),
        rect(height: 4pt, fill: pale-warm, radius: 2pt),
      )
      #v(30pt)
      #text(font: sans-font, size: 9pt, fill: muted)[#author]
      #v(5pt)
      #text(font: sans-font, size: 7.5pt, fill: muted)[#edition]
    ]
  ]
  pagebreak()
}

#let title-page(title: "", subtitle: "", author: "", date: "") = {
  align(center + horizon)[
    #text(font: sans-font, size: 20pt, weight: 700)[#title]
    #v(10pt)
    #text(font: sans-font, size: 10pt, fill: accent-dark)[#subtitle]
    #v(25pt)
    #text(font: sans-font, size: 9pt)[#author]
    #v(4pt)
    #text(font: sans-font, size: 8pt, fill: muted)[#date]
  ]
  pagebreak()
}

#let part-page(number: "", title: "", body) = {
  pagebreak(weak: true)
  align(center + horizon)[
    #block(width: 86%)[
      #text(font: sans-font, size: 8pt, fill: accent, tracking: 0.12em)[第 #number 部]
      #v(7pt)
      #text(font: sans-font, size: 23pt, weight: 750, fill: ink)[#title]
      #v(10pt)
      #line(length: 22mm, stroke: 1.6pt + warm)
      #v(14pt)
      #block[
        #set text(size: 9.2pt, fill: muted)
        #set par(first-line-indent: 0em, justify: false, leading: 0.8em)
        #body
      ]
    ]
  ]
  pagebreak()
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

#let case-study(title: [Kokage での確認], body) = block(
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
