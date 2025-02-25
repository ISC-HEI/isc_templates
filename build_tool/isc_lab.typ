// Typst configuration for ISC Lab
// version: 0.1
// author: Pierre-André Mudry
// Basic usage:
//      pandoc mylab.md \
//      --wrap=none \
//      --pdf-engine=typst \
//      --template=isc_lab_typ  \
//     -o mylab.pdf

// TODO: 
// - Footnotes not tested yet
// - Figure number not included for typst (comme sur la figure 3)
// - How are \newpage handled?
// - How to edit metadata such as creator ? It seems not feasible at the moment but pdf-meta can be used

#let horizontalrule = [
  #v(1pt)
  #line(start: (25%, 0%), end: (75%, 0%), stroke: 1pt + white)
  #v(1pt)
]

// Template defaults
#let conf(
  title: none,
  subtitle: none,
  authors: none, // IF NOT IN METADATA
  date: datetime.today().display(), // IF NOT IN METADATA
  lang: "fr",
  region: "CH",
  font: "Times New Roman",
  papersize: "a4",
  version: none,
  module: none,
  ue: none,
  course: none,
  fontsize: 10pt,
  sectionnumbering: none,
  doc,
) = {

  let body-font = ("Source Sans 3", "Libertinus Serif")
  let sans-font = ("Source Sans 3")
  let raw-font = "Fira Code"
  let math-font = ("New Computer Modern Math", "Asana Math", "Fira Math")

  show terms: it => {
    it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
    ])
    .join()
  }

  // Document language for hyphenation and other things
  let internal-language = lang

  // Default body font
  set text(font: body-font, size: fontsize, alternates: false, lang: internal-language)

  // Set other fonts
  show math.equation: set text(font: math-font, size:1.1em) // For math equations
  show math.equation.where(block: true): set par(leading: 1em) // Add space between equations in math mode
  set math.cases(gap:.8em) // Gap between cases in math mode
  show raw: set text(font: raw-font) // For code
  show heading: set text(font: sans-font) // For sections, sub-sections etc..

  /////////////////////////////////////////////////
  //  Basic pagination and typesetting
  /////////////////////////////////////////////////
  set page(
    // margin: (inside: 2cm, outside: 1.5cm, y: 2.1cm), // Binding inside
    margin: (left: 1.8cm, right: 1.5cm, top: 2.5cm, bottom: 2.4cm), // Binding inside
    paper: "a4",
  )

  let space-after-heading = 0.5em
  show heading: it => { it; v(space-after-heading) } // Space after heading

  let authors-str = ()

  if (authors.len() > 1) {
    authors-str = authors.map(x => x.name).join(", ")
  } else {
    authors-str = authors.at(0)
  }

  let content-to-string(content) = {
    if content.has("text") {
      content.text
    } else if content.has("children") {
      content.children.map(content-to-string).join("")
    } else if content.has("body") {
      content-to-string(content.body)
    } else if content == [ ] {
      " "
    }
  }

  // Set PDF properties
  set document(
    title: [$title$],
    author: content-to-string(authors-str),
    keywords: ("$ue$", "$course$", "ISC", "HEI", "Sion"),
  )

  // Header and footer formatting
  let header-content = text(0.87em)[
    #text(title)
    #h(1fr)
    #date, v#text(version)
  ]

  let footer-content = context text(0.8em)[
    #text(authors-str) | #emph(ue) #emph(course)
    #h(1fr)
    #counter(page).display("1 | 1", both: true)
  ]

  // Set header and footers insertion
  set page(
    // For pages other than the first one
    header: context if counter(page).get().first() > 1 [
      #header-content
      #move(dy: -7pt, line(length: 100%, stroke: 0.5pt))
    ],
    header-ascent: 20%,
    // For pages other than the first one
    footer: context if counter(page).get().first() >= 1 [
      #move(dy: 5pt, line(length: 100%, stroke: 0.5pt))
      #footer-content
    ],
  )

  // Links coloring
  show link: set text(ligatures: true, fill: color.rgb(77,118,187))

  // Sections numbers
  // set heading(numbering: "1.1.1 -")

  // BASIC BODY PARAGRAPH FORMATTING
  // show par: set block(spacing: 8pt)// Same as leading, no para space
  set par( first-line-indent: 1.5em, leading: 8pt, justify: true)
  //set text(lang: lang, font: font, size: fontsize, alternates: false)

  // Block quotations
  set quote(block: true) 
  // show quote: set block(spacing: 1em, outset: (x:-1em, y:0em), fill: luma(95%), width: 100%) 
  show quote: set block(spacing: 1em, fill: luma(95%), width: auto) 
  show quote: set pad(x: 0.9em, y: .6em)// Margins around the block
  // show quote: set par(leading: 8pt)
  show quote: set text(fill: luma(50%)) 
  show quote.where(block: true): block.with(stroke: (left:6pt + black, rest: none))

  // show quote: set text(style: "italic")

  // Images and figures:
  set image(width: 5.25in, fit: "contain") 
  show image: it => { align(center, it) }

  // Figure numbering with whole numbers, in bold and with a nice separator
  set figure(numbering: "1", gap: 0.8em, supplement: text("Figure", weight: "bold"))

  // Make the caption like I like them
  show figure.caption: it => context {
      if it.numbering == none {
        it.body
      } else {
        text(fill:black, weight: "bold")[#it.supplement #it.counter.display()] + " " + it.separator + it.body
      }
    }
  show figure.caption: set text(size: 10pt, fill: luma(40%)) // Caption text
  set figure.caption(separator: "-") // With a nice separator

  // Code snippets:
  // show raw: set block(inset: (left: 2em, top: 0.5em, right: 1em, bottom: 0.5em ))
  // Set raw text color to something light but nice
  show raw: set text(fill: rgb("#6b194a"), size: 9pt)

  // Footnotes formatting
  set footnote.entry(indent: 0.5em)
  show footnote.entry: set par(hanging-indent: 1em)
  show footnote.entry: set text(size: 9pt, weight: 200)

  // Lists
  set list(indent: 10pt)//, marker:([•], [‣], [–]))
  set enum(indent: 10pt)

  // Code blocks configuration
  set raw(theme: "figs_template/GitHub.tmTheme")
  import "@preview/codly:1.1.0": *
  import "@preview/codly-languages:0.1.3": *
  show: codly-init.with()
  codly(
    languages: codly-languages,
    smart-indent: true,
    zebra-fill: none,
    display-icon: false,
    display-name: false,
    number-align: right+top,
    stroke: .5pt + luma(70),
    radius: 0.5em,
    inset: (x: .5em, y: 0.2em),
    lang-outset: (x: -3pt, y: 5pt),
    fill: luma(97%),
  )

  codly(number-format: (n) => box(fill: luma(97%), height: 1em, baseline:5pt, outset: .1em)[#text(luma(140), baseline: .3em, size: .8em)[#str(n)]])
  
  codly-enable()

  // Headings (corresponds to # ## ###) configuration
  show heading: set text(hyphenate: false)

  let line_spacing_around_heading = 0.75em

  show heading.where(level: 1
    ):  it => align(left, block(above: 18pt, below: 11pt, width: 100%)[
        #set par(leading: 11pt) // used ?
        //#set text(font: ("Helvetica", "Arial"), weight: "semibold", size: 14pt)
        #move(dy: line_spacing_around_heading, line(length: 100%, stroke: 0.5pt + luma(20%)))
        #block(
          it.body
        ) 
        #move(dy: -line_spacing_around_heading, line(length: 100%, stroke: 0.5pt + luma(20%)))
        #v(-12pt)
      ])

  show heading.where(level: 2
    ): it => align(left, block(above: 16pt, below: 11pt, width: 80%)[
        #block(it.body) 
      ])

  // Not used currently but left for reference
  // show heading.where(level: 3
  //   ): it => align(left, block(above: 18pt, below: 11pt)[
  //       #set text(font: "Times New Roman", weight: "regular", style: "italic", size: 11pt)
  //       #block(it.body) 
  //     ])

  // Define our own functions
  let todo(body, fill-color: yellow.lighten(50%)) = {
    set text(black)
    box(baseline: 25%, fill: fill-color, inset: 3pt, [*TODO* #body])
  }

  // ***************************************************
  // ** Document layout logic
  // ***************************************************
  
  // TITLE block
  v(30pt)

  align(left, text(size: 24pt, weight: "bold")[
    #set par(justify: false)
    #title])

  v(-20pt)
  align(left, text(size: 12pt)[
      #set par(first-line-indent: 0em, justify: false)
      #ue -- #course
  ]) 

  let insert-logo(logo) = {
    if logo != none {
      place(
        top + right,
        dx: 32mm,
        dy: -12mm,
        clearance: 0em,
        // Put it in a box to be resized
        box(height:1.65cm, logo)
      )
    }
  }

  insert-logo(image("figs_template/ISC_logo_inline_v1_FR.svg"))

  // Now we insert the content, here
  counter(page).update(1)// start page numbering
  doc

} // end of #let conf block

// BOILERPLATE PANDOC TEMPLATE:
#show: doc => conf(
  $if(title)$
    title: [$title$],
  $endif$
  $if(subtitle)$
    subtitle: [$subtitle$],
  $endif$
  $if(author)$
    authors: (
  $for(author)$
  $if(author.name)$
      ( name: [$author.name$],
        affiliation: [$author.affil$],
        email: [$author.email$] ),
  $else$
      ( name: [$author$],
        affiliation: [],
        email: [] ),
  $endif$
  $endfor$
      ),
  $endif$
  $if(venue)$
    venue: [$venue$],
  $endif$
  $if(date)$
    date: [$date$],
  $endif$
  $if(lang)$
    lang: "$lang$",
  $endif$
  $if(region)$
    region: "$region$",
  $endif$
  $if(abstract)$
    abstract: [$abstract$],
  $endif$
  $if(margin)$
    margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
  $endif$
  $if(papersize)$
    paper: "$papersize$",
  $endif$
  $if(version)$
    version: "$version$",
  $endif$
  $if(module)$
    module: "$module$",
  $endif$
  $if(ue)$
    ue: "$ue$",
  $endif$
  $if(course)$
    course: "$course$",
  $endif$
  $if(section-numbering)$
    sectionnumbering: "$section-numbering$",
  $endif$
    doc,
)

// Include before
$for(include-before)$
$include-before$

$endfor$

$if(toc)$
#outline(title: auto, depth: $toc-depth$);
$endif$

/**
 * BODY - Where the MD is emitted
 **/
$body$

/**
 * EPILOGUE - After the body
 **/
$if(citations)$
$if(bibliographystyle)$

#set bibliography(style: "$bibliographystyle$")
$endif$
$if(bibliography)$

#bibliography($for(bibliography)$"$bibliography$"$sep$, $endfor$)
$endif$
$endif$
$for(include-after)$

$include-after$
$endfor$

// This is the end