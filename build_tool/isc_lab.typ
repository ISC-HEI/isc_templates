// Typst configuration for ISC Lab
// version: 0.1
// author: Pierre-André Mudry
// Basic usage:
//      pandoc mylab.md \
//      --wrap=none \
//      --pdf-engine=typst \
//      --template=isc_lab_typ  \
//     -o mylab.pdf

#let horizontalrule = [
  #v(1pt)
  #line(start: (25%, 0%), end: (75%, 0%), stroke: 1pt + white)
  #v(1pt)
]

/**
 * PROLOGUE
 **/

// SET BASIC TEMPLATE DEFAULTS:
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
  let math-font = ("Asana Math", "Fira Math")

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
  // show math.equation: set text(font: math-font) // For math equations
  show raw: set text(font: raw-font) // For code
  show heading: set text(font: sans-font) // For sections, sub-sections etc..

  /////////////////////////////////////////////////
  //  Basic pagination and typesetting
  /////////////////////////////////////////////////
  set page(
    margin: (inside: 2cm, outside: 1.5cm, y: 2.1cm), // Binding inside
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

  let header-content = text(0.75em)[
    #emph(authors-str)
    #h(1fr)
    #emph(version)
  ]

  let footer-content = context text(0.75em)[
    #emph(title)
    #h(1fr)
    #counter(page).display("1/1", both: true)
  ]

  // Set header and footers
  set page(
    // For pages other than the first one
    header: context if counter(page).get().first() > 1 {
      header-content
    },
    header-ascent: 40%,
    // For pages other than the first one
    footer: context if counter(page).get().first() > 1 [
      #move(dy: 5pt, line(length: 100%, stroke: 0.5pt))
      #footer-content
    ],
  )

  // Links coloring
  show link: set text(ligatures: true, fill: blue)

  // Sections numbers
  // set heading(numbering: "1.1.1 -")

  // BASIC BODY PARAGRAPH FORMATTING
  // show par: set block(spacing: 8pt)// Same as leading, no para space
  set par( first-line-indent: 1.5em, leading: 8pt, justify: true)
  //set text(lang: lang, font: font, size: fontsize, alternates: false)

  // Block quotations
  set quote(block: true) 
  show quote: set block(spacing: 18pt) 
  show quote: set pad (x: 2em)// L&R margins
  show quote: set par(leading: 8pt) 
  show quote: set text(style: "italic")

  // Images and figures:
  set image(width: 5.25in, fit: "contain") 
  show image: it => { align(center, it) }
  set figure(gap: 0.5em, supplement: none)
  show figure.caption: set text(size: 9pt)

  // Code snippets:
  show raw: set block(inset: (left: 2em, top: 0.5em, right: 1em, bottom: 0.5em ))
  show raw: set text(fill: rgb("#116611"), size: 9pt) //green

  // Footnote formatting
  set footnote.entry(indent: 0.5em)
  show footnote.entry: set par(hanging-indent: 1em)
  show footnote.entry: set text(size: 9pt, weight: 200)

  // Lists
  set list(indent: 10pt)//, marker:([•], [‣], [–]))
  set enum(indent: 10pt)

  // Headings configuration
  show heading: set text(hyphenate: false)

  show heading.where(level: 1
    ):  it => align(left, block(above: 18pt, below: 11pt, width: 100%)[
        #set par(leading: 11pt) // used ?
        //#set text(font: ("Helvetica", "Arial"), weight: "semibold", size: 14pt)
        #move(dy: 14pt, line(length: 100%, stroke: 0.5pt + luma(20%)))
        #block(
          it.body
        ) 
        #move(dy: -14pt, line(length: 100%, stroke: 0.5pt + luma(20%)))
        #v(-12pt)
      ])

  show heading.where(level: 2
    ): it => align(left, block(above: 16pt, below: 11pt, width: 80%)[
        #block(it.body) 
      ])

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

  // THIS IS THE ACTUAL BODY:
  counter(page).update(1)// start page numbering
  doc// this is where the content goes

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

// The end
