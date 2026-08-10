// 配色はアプリのロゴから取る(深緑 #2d4d42・ミント #a8d2c2・クリーム #fdf2e1)。
#let ink = rgb("#222b26")
#let muted = rgb("#67746d")
#let accent = rgb("#2d4d42")
#let accent-dark = rgb("#1d382f")
#let mint = rgb("#a8d2c2")
#let cream = rgb("#fdf2e1")
#let warm = rgb("#a05e3b")
#let paper = rgb("#fcfbf7")
#let pale = rgb("#eef4f0")
#let pale-warm = rgb("#f9efe0")
#let rule = rgb("#ccd7d0")

#let body-font = "Hiragino Mincho ProN"

#let sans-font = "Hiragino Sans"

#let mono-font = "Menlo"

// アプリのロゴ。assets/ の3種は、こかげ本体が配布しているアイコンと同じ作画。
// 透過マーク(枠なし)は表紙の地と扉、マスカブル(暗地に原寸マーク)は奥付に使う。
// 標準アイコン(暗地に拡大マーク)はいま未使用だが、関数は残す。
#let logo-icon(size) = box(radius: size * 0.22, clip: true, image("assets/logo-icon.svg", width: size))
#let logo-mark(size) = image("assets/logo-mark.svg", height: size)
#let logo-maskable(size) = box(radius: size * 0.22, clip: true, image("assets/logo-maskable.svg", width: size))

// 表の最下段の罫。行数を様式側で知る場所が無いため、各表が末尾に置く。
#let table-bottomrule = table.hline(stroke: 0.7pt + rule.darken(45%))

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
  // 項目間の空きは本文の行送り(0.78em)と同じにする。これより狭いと、
  // 折り返しを含む項目では、項目の内側より境目のほうが詰まって見える。
  set list(
    indent: 1.1em,
    body-indent: 0.55em,
    spacing: 0.78em,
    marker: (text(fill: accent)[•], text(fill: muted, size: 0.85em)[◦]),
  )
  set enum(indent: 1.1em, body-indent: 0.55em, spacing: 0.78em)
  // 表は縦罫を引かない三線表。見出し行の罫は行本体に持たせ、
  // ページ跨ぎで table.header が繰り返されても罫が付いて回るようにする。
  set table(
    stroke: (x, y) => (
      left: none,
      right: none,
      top: if y == 0 { 0.7pt + rule.darken(45%) }
        else if y == 1 { none }
        else { 0.3pt + rule.lighten(20%) },
      bottom: if y == 0 { 0.45pt + rule.darken(45%) } else { none },
    ),
    inset: (x: 6pt, y: 4.5pt),
  )
  show table.cell.where(y: 0): set text(font: sans-font, size: 7.9pt, weight: 600, fill: accent-dark)
  set figure(gap: 8pt)
  set figure.caption(separator: [#h(0.55em)])
  show figure.caption: set text(font: sans-font, size: 7.8pt, fill: muted)
  show raw: set text(font: mono-font, size: 7.7pt)

  // 原稿は一文一行で書くため、行末が約物のときに入る欧文スペースを取り除く。
  // 改行そのもの(#linebreak())は対象にせず、スペースだけを詰める。
  show regex("[。、!?」』)] "): it => it.text.trim()
  // 約物が連続するとき(。「 や 」。など)は、間の空きを半角分に詰める。
  // box で包むと改行判定から約物が隠れ、行頭に句読点が落ちるため、
  // 行末・行頭で消える weak な負スペースで詰める。
  // 半角括弧は約物詰めの対象にしない。全角約物と違って字面に余白がなく、
  // 負スペースを入れると隣の句読点や括弧と重なって消える()。 や 」( で顕在化)。
  // 末尾の「 ?」は、この規則が句読点を消費すると前段の空白除去規則が
  // 届かなくなるため、原稿改行由来の後続スペースをここで一緒に取り除く。
  show regex("[。、」』] ?[「『。、] ?"): it => {
    let chars = it.text.replace(" ", "").clusters()
    [#chars.at(0)#h(-0.5em, weak: true)#chars.at(1)]
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
      #set par(justify: false, first-line-indent: 0em)
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
      #line(length: 24mm, stroke: 1.5pt + accent)
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
    #line(length: 24mm, stroke: 1.5pt + accent)
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
) = page(margin: 0mm, fill: paper, header: none, footer: none)[
  #set text(font: sans-font, fill: ink)

  // ひとこと(タイトルの上の帯。地の深緑と文字のクリームはロゴの配色)
  #if title-note != none {
    place(top + left, dx: 18mm, dy: 28mm,
      box(fill: accent, inset: (x: 3mm, y: 1.9mm), radius: 0.7mm,
        text(size: 9.3pt, weight: 600, fill: cream, tracking: 0.09em)[#title-note]))
  }

  // タイトル(上の目印は、アプリのアイコンと同じ2枚葉)
  #place(top + left, dx: 18mm, dy: 41mm,
    image("assets/logo-leaves.svg", height: 9.5mm))
  #place(top + left, dx: 18mm, dy: 53mm, {
    set par(leading: 0.48em)
    text(size: 30pt, weight: 700)[#title]
  })

  // サブタイトル
  #place(top + left, dx: 18mm, dy: 86mm, {
    set par(leading: 0.85em)
    text(size: 10pt, weight: 600, fill: ink, tracking: 0.02em)[#subtitle]
  })

  // 地の書誌情報(枠なしの透過マークと著者名の横組み。発行日は奥付だけに書く)
  #place(bottom + left, dx: 18mm, dy: -20mm,
    grid(
      columns: (auto, auto),
      column-gutter: 4mm,
      align: horizon,
      logo-mark(13mm),
      text(size: 9.5pt, weight: 600)[#author],
    ))
]

#let title-page(title: "", subtitle: "", author: "") = {
  page(header: none, footer: none)[
    #align(center + horizon)[
      #logo-mark(15mm)
      #v(10pt)
      #text(font: body-font, size: 20pt, weight: 600, fill: ink)[#title]
      #v(13pt)
      #text(font: sans-font, size: 9.5pt, fill: accent-dark)[#subtitle]
      #v(30pt)
      #text(font: sans-font, size: 9pt, fill: ink)[#author]
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
  printer: none,
  url: "",
  x-account: none,
) = {
  page(header: none, footer: none)[
    #align(bottom)[
      #set text(font: sans-font)
      #set par(first-line-indent: 0em, justify: false, leading: 0.6em)
      #logo-maskable(10mm)
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
          (
            ([発行], [#edition]),
            ([著者], [#author]),
            ([組版], [Typst 0.15 (ヒラギノ明朝 ProN・ヒラギノ角ゴシック・Menlo)]),
          )
          + (if printer == none { () } else { (([印刷所], [#printer]),) })
          + (
            ([配布], [#link(url)[#url]]),
          )
          + (if x-account == none { () } else {
            // 𝕏(U+1D54F)はヒラギノに無いため、この一字だけ STIX Two Math で描く
            (([#text(font: "STIX Two Math")[𝕏]], [#link("https://x.com/" + x-account)[\@#x-account]]),)
          })
          + (
            ([利用条件], [CC BY-NC-SA 4.0 (表示・非営利・継承)]),
          )
        ).map(((label, value)) => (
          text(size: 7.4pt, weight: 600, fill: muted, tracking: 0.08em)[#label],
          text(size: 8pt, fill: ink)[#value],
        )).flatten()
      )
      #v(16pt)
      #text(size: 7.2pt, fill: muted)[© 2026 Project Kokage]
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

// 囲みは枠線を引かず、淡い塗りだけで区切る(枠+塗り+角丸の三重は画面の部品めく)。
#let key-point(title: [設計の要点], body) = block(
  above: 12pt,
  below: 12pt,
  inset: (x: 11pt, y: 10pt),
  fill: pale,
  radius: 3pt,
  breakable: true,
)[
  #set par(first-line-indent: 0em)
  #text(font: sans-font, size: 8.4pt, weight: 700, fill: accent)[#title]
  #v(5pt)
  #body
]

#let caution(title: [判断を誤りやすい点], body) = block(
  above: 12pt,
  below: 12pt,
  inset: (x: 11pt, y: 10pt),
  fill: pale-warm,
  radius: 3pt,
  breakable: false,
)[
  #set par(first-line-indent: 0em)
  #text(font: sans-font, size: 8.4pt, weight: 700, fill: warm)[#title]
  #v(5pt)
  #body
]

#let case-study(title: [こかげでの確認], body) = block(
  above: 12pt,
  below: 12pt,
  inset: (left: 11pt, right: 10pt, top: 8pt, bottom: 8pt),
  stroke: (left: 2pt + accent),
  breakable: true,
)[
  #set par(first-line-indent: 0em)
  #text(font: sans-font, size: 8.2pt, weight: 700, fill: accent-dark)[#title]
  #v(4pt)
  #set text(size: 8.4pt)
  #body
]

// 図表は箱で囲まず、表の三線罫とキャプションだけで見せる。
// kind は表なら自動判定に任せ、図解(表を含まない body)だけ image を明示する。
// placement: none は本文の流れに固定する(浮動だと breakable な囲みの途中に割り込む)。
#let figure-panel(caption: none, kind: auto, placement: auto, body) = figure(
  placement: placement,
  kind: kind,
  block(width: 100%)[
    #set par(first-line-indent: 0em)
    #body
  ],
  caption: caption,
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
