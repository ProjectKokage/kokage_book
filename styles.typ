// Hallmark · pre-emit critique: P5 H5 E5 S5 R5 V4
// Hallmark · editorial · 静謐で硬質 · 深緑 · Long Document / 一段組
// 配色はアプリのロゴから取る(深緑 #2d4d42・ミント #a8d2c2・クリーム #fdf2e1)。
#let ink = rgb("#222b26")
#let muted = rgb("#58655e")
#let accent = rgb("#2d4d42")
#let accent-dark = rgb("#1d382f")
#let mint = rgb("#a8d2c2")
#let cream = rgb("#fdf2e1")
#let warm = rgb("#9c5936")
#let paper = rgb("#fcfbf7")
#let pale = rgb("#eef4f0")
#let pale-warm = rgb("#f9efe0")
#let rule = rgb("#ccd7d0")

#let body-font = "Hiragino Mincho ProN"

#let sans-font = "Hiragino Sans"

#let mono-font = "Menlo"

#let symbol-font = "STIX Two Math"

// JIS B5 の一段組。本文はおよそ 38〜40 字で折り返す。
#let bleed = 3mm
#let body-size = 10pt
#let body-leading = 0.72em

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

#let book(title: "", page-fill: paper, body) = {
  set document(title: title)
  set page(
    paper: "jis-b5",
    bleed: bleed,
    binding: left,
    fill: page-fill,
    margin: (
      top: 22mm,
      bottom: 23mm,
      inside: 25mm,
      outside: 20mm,
    ),
    header-ascent: 8.5mm,
    footer-descent: 9.5mm,
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
            set text(font: sans-font, size: 7.3pt, fill: muted, tracking: 0.04em)
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
        set text(font: sans-font, size: 7.6pt, fill: muted)
        if calc.even(page-number) {
          align(left)[#counter(page).display("1")]
        } else {
          align(right)[#counter(page).display("1")]
        }
      }
    },
    numbering: "1",
  )

  set text(
    font: body-font,
    size: body-size,
    fill: ink,
    lang: "ja",
    region: "JP",
  )
  set par(
    justify: true,
    leading: body-leading,
    spacing: 0.48em,
    first-line-indent: (amount: 1em, all: true),
  )
  set heading(numbering: "1.1")
  // 項目間の空きは本文の行送りと同じにする。これより狭いと、
  // 折り返しを含む項目では、項目の内側より境目のほうが詰まって見える。
  set list(
    indent: 1.1em,
    body-indent: 0.55em,
    spacing: body-leading,
    marker: (text(fill: accent)[•], text(fill: muted, size: 0.85em)[◦]),
  )
  set enum(indent: 1.1em, body-indent: 0.55em, spacing: body-leading)
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
    inset: (x: 6.5pt, y: 5pt),
  )
  show table.cell.where(y: 0): set text(font: sans-font, size: 8.6pt, weight: 600, fill: accent-dark)
  set figure(gap: 8pt)
  set figure.caption(separator: [#h(0.55em)])
  show figure.caption: set text(font: sans-font, size: 8.4pt, fill: muted)
  show raw: set text(font: mono-font, size: 8.3pt)

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
      below: 24pt,
      breakable: false,
      sticky: true,
    )[
      #set par(justify: false, first-line-indent: 0em)
      #context {
        let eyebrow = heading-label(it)
        if eyebrow != none {
          grid(
            columns: (auto, 1fr),
            column-gutter: 10pt,
            align: horizon,
            text(font: sans-font, size: 8.4pt, weight: 600, fill: accent, tracking: 0.16em)[#eyebrow],
            line(length: 100%, stroke: 0.5pt + rule),
          )
        }
      }
      #v(12pt)
      #text(font: sans-font, size: 23.5pt, weight: 700, fill: ink, tracking: -0.01em)[#it.body]
      #v(10pt)
      #line(length: 24mm, stroke: 1.3pt + accent)
    ]
  }

  show heading.where(level: 2): it => {
    block(
      above: 18pt,
      below: 8pt,
      breakable: false,
      sticky: true,
    )[
      #set par(justify: false, first-line-indent: 0em)
      #if it.numbering != none {
        context text(font: sans-font, size: 9.3pt, weight: 700, fill: accent)[#counter(heading).display(it.numbering)]
        h(9pt)
      }
      #text(font: sans-font, size: 14pt, weight: 700, fill: ink)[#it.body]
    ]
  }

  show heading.where(level: 3): it => {
    block(
      above: 12pt,
      below: 5pt,
      breakable: false,
      sticky: true,
    )[
      #text(font: sans-font, size: 10.8pt, weight: 700, fill: accent-dark)[#it.body]
    ]
  }

  show quote: it => block(
    inset: (left: 11pt, right: 9pt, top: 8pt, bottom: 8pt),
    stroke: (left: 0.8pt + accent),
    fill: pale,
    radius: (right: 0.8pt),
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
  block(below: 22pt, breakable: false)[
    #text(font: sans-font, size: 23.5pt, weight: 700, fill: ink)[目次]
    #v(10pt)
    #line(length: 24mm, stroke: 1.3pt + accent)
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
        block(above: 8.5pt, below: 5.5pt)[
          #link(ev.location())[
            #box(width: 29pt, text(size: 7.7pt, weight: 600, fill: accent)[#heading-label(ev)])
            #text(size: 9.9pt, weight: 600, fill: ink)[#ev.body]
            #box(width: 1fr)
            #text(size: 8.7pt, weight: 600, fill: ink)[#page-no]
          ]
        ]
      } else if ev.level == 2 {
        let page-no = counter(page).at(ev.location()).first()
        block(above: 3.8pt, below: 3.8pt)[
          #link(ev.location())[
            #h(29pt)
            #box(width: 24pt, text(size: 7.9pt, fill: muted)[#numbering(ev.numbering, ..counter(heading).at(ev.location()))])
            #text(size: 8.9pt, fill: ink)[#ev.body]
            #box(width: 1fr, align(right, box(inset: (x: 4pt), text(size: 7.6pt, fill: rule.darken(15%))[#repeat([.], gap: 3.2pt)])))
            #text(size: 8.3pt, fill: muted)[#page-no]
          ]
        ]
      }
    }
  }
}

// 表紙。地を深緑の面にし、文字組と余白だけで構成する。地色はロゴの深緑で、
// アプリの標準アイコン(暗地にマーク)と同じ構図になる。
#let cover-art(
  title: "",
  title-note: none,
  subtitle: "",
  author: "",
  x-offset: 0mm,
) = [
  #set text(font: sans-font, fill: cream)

  // ひとこと(タイトルの上の帯。深緑の地に対してクリーム地へ反転させる)
  #if title-note != none {
    place(top + left, dx: x-offset + 24mm, dy: 50mm,
      box(fill: cream, inset: (x: 4.2mm, y: 2.6mm), radius: 0.15mm,
        text(size: 12pt, weight: 600, fill: accent-dark, tracking: 0.09em)[#title-note]))
  }

  // タイトル(上の目印は、アプリのアイコンと同じ2枚葉)
  #place(top + left, dx: x-offset + 24mm, dy: 62.5mm,
    image("assets/logo-leaves.svg", height: 9.5mm))
  #place(top + left, dx: x-offset + 24mm, dy: 76mm, {
    set par(leading: 0.52em)
    text(size: 36pt, weight: 700, tracking: -0.02em)[#title]
  })

  // サブタイトル(ミントはロゴの葉の色)
  #place(top + left, dx: x-offset + 24mm, dy: 116mm, {
    set par(leading: 0.85em)
    text(size: 11.4pt, weight: 500, fill: mint, tracking: 0.03em)[#subtitle]
  })

  // 地の書誌情報(枠なしの透過マークと著者名の横組み。発行日は奥付だけに書く。
  // マークの深緑の影は地に溶け、ミントの本体だけが浮かぶ)
  #place(bottom + left, dx: x-offset + 24mm, dy: -24mm,
    grid(
      columns: (auto, auto),
      column-gutter: 4.5mm,
      align: horizon,
      logo-mark(15mm),
      text(size: 10.5pt, weight: 600, tracking: 0.02em)[#author],
    ))
]

#let cover(
  title: "",
  title-note: none,
  subtitle: "",
  author: "",
) = page(margin: 0mm, fill: accent, header: none, footer: none)[
  #cover-art(
    title: title,
    title-note: title-note,
    subtitle: subtitle,
    author: author,
  )
]

// 左綴じの見開き表紙。左から表4、背、表1の順で置く。
// 背と表4には文字を置かず、表1と同じ深緑を外周の塗り足しまで続ける。
#let cover-spread(
  title: "",
  title-note: none,
  subtitle: "",
  author: "",
  spine: 0mm,
) = page(
  width: 364mm + spine,
  height: 257mm,
  bleed: bleed,
  margin: 0mm,
  fill: accent,
  header: none,
  footer: none,
)[
  #cover-art(
    title: title,
    title-note: title-note,
    subtitle: subtitle,
    author: author,
    x-offset: 182mm + spine,
  )
]

// 印刷用本文の2ページ目。表紙を本文へ混ぜず、序章以降の左右配置と
// ノンブルを通常版から動かさないための白紙ページ。
#let print-blank-page() = page(
  fill: white,
  header: none,
  footer: none,
)[#metadata("blank-page")]

#let title-page(title: "", subtitle: "", author: "") = {
  page(header: none, footer: none)[
    #align(center + horizon)[
      #logo-mark(15mm)
      #v(12pt)
      #text(font: body-font, size: 22pt, weight: 600, fill: ink)[#title]
      #v(15pt)
      #text(font: sans-font, size: 10pt, fill: accent-dark)[#subtitle]
      #v(34pt)
      #text(font: sans-font, size: 9.5pt, fill: ink, tracking: 0.02em)[#author]
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
  continuous-url: none,
  versioned-url: none,
  x-account: none,
  contact: none,
) = {
  page(header: none, footer: none)[
    #align(bottom)[
      #set text(font: sans-font)
      #set par(first-line-indent: 0em, justify: false, leading: 0.6em)
      #logo-maskable(10mm)
      #v(6pt)
      #line(length: 100%, stroke: 0.6pt + rule)
      #v(13pt)
      #text(size: 11.8pt, weight: 700, fill: ink)[#title]
      #v(4pt)
      #text(size: 8.1pt, fill: muted)[#subtitle]
      #v(10pt)
      #block[
        #set text(size: 8.1pt, fill: ink)
        筆者らは本書を随時更新する。
        原稿と組版用コードを GitHub で公開し、CI で組版した最新版と、バージョン番号を付けた最新リリース版を配布する。
      ]
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
          + (if continuous-url == none { () } else {
            (([最新版], [#link(continuous-url)[PDF をダウンロード]]),)
          })
          + (if versioned-url == none { () } else {
            (([リリース版], [#link(versioned-url)[最新のバージョン付き PDF をダウンロード]]),)
          })
          + (if x-account == none { () } else {
            // 𝕏(U+1D54F)はヒラギノに無いため、この一字だけ STIX Two Math で描く
            (([#text(font: symbol-font)[𝕏]], [#link("https://x.com/" + x-account)[\@#x-account]]),)
          })
          + (if contact == none { () } else {
            (([連絡先], [#link("mailto:" + contact)[#contact]]),)
          })
          + (
            ([利用条件], [CC BY-NC-SA 4.0 (表示・非営利・継承)]),
          )
        ).map(((label, value)) => (
          text(size: 7.8pt, weight: 600, fill: muted, tracking: 0.08em)[#label],
          text(size: 8.5pt, fill: ink)[#value],
        )).flatten()
      )
      #v(16pt)
      #text(size: 7.6pt, fill: muted)[© 2026 Project Kokage]
    ]
  ]
}

#let chapter-lead(body) = block(
  below: 14pt,
)[
  #set text(size: 10.8pt, fill: accent-dark)
  #set par(first-line-indent: 0em, leading: 0.82em)
  #body
]

// 囲みは枠線を引かず、淡い塗りだけで区切る(枠+塗り+角丸の三重は画面の部品めく)。
#let key-point(title: [設計の要点], body) = block(
  above: 12pt,
  below: 12pt,
  inset: (x: 11pt, y: 10pt),
  fill: pale,
  radius: 1.2pt,
  breakable: false,
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
  radius: 1.2pt,
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
  stroke: (left: 1pt + accent),
  breakable: false,
)[
  #set par(first-line-indent: 0em)
  #text(font: sans-font, size: 8.5pt, weight: 700, fill: accent-dark)[#title]
  #v(4pt)
  #set text(size: 9pt)
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
  stroke: 0.5pt + rule,
  radius: 1pt,
)[
  #align(center)[
    #set text(font: sans-font, size: 8.4pt)
    #body
  ]
]

#let flow-arrow = text(font: sans-font, size: 9pt, fill: accent)[↓]

#let source-link(label, url) = link(url)[#label]
