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
// - Equation not displayed similarly to LaTex --> almost fixed, have to increase space between equations
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
    title: [Labo 3 -- Test et boucles],
    author: content-to-string(authors-str),
    keywords: ("101.1", "Programmation
impérative", "ISC", "HEI", "Sion"),
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
      title: [Labo 3 -- Test et boucles],
          authors: (
          ( name: [Dr Pierre-André Mudry],
        affiliation: [],
        email: [] ),
            ( name: [Marc Pignat],
        affiliation: [],
        email: [] ),
          ),
          date: [28.1.2024],
        lang: "fr",
                version: "1.2.0",
        module: "101",
        ue: "101.1",
        course: "Programmation impérative",
        doc,
)

// Include before


/**
 * BODY - Where the MD is emitted
 **/
= Objectifs et donnée du laboratoire
<objectifs-et-donnée-du-laboratoire>
+ Le but de ce laboratoire est de se familiariser avec les modifications
  du flux séquentiel d'un programme, en utilisant des conditions et des
  boucles. Nous introduirons également la classe `FunGraphics` qui est
  une librairie de dessin permettant de dessiner dans une fenêtre
  graphique.

+ La durée estimée pour réaliser ce laboratoire est de #strong[4
  périodes];.

+ Vous pouvez trouver cette donnée sous forme électronique se trouve sur
  le #link("https://isc.hevs.ch/learn")[site web du cours];. Vous y
  trouverez également la solution dès la semaine prochaine.

= Partie 1 - Exemples simples de tests et de boucles
<partie-1---exemples-simples-de-tests-et-de-boucles>
== Tâche 1 -- Boucle
<tâche-1-boucle>
+ Créez un projet `Lab3` comme vu dans le labo précédent.

+ Ajoutez une classe `Lab3_Task1` à votre projet et écrivez le programme
  ci-dessous (et qui ressemble à un exercice de la série 3):

  ```scala
  object Lab3_Task1 extends App {
      var x:Int = 0
      var i:Int = 0

      while (i < 10) {
          println("Number : " + x)
          x += 1
      }
  }
  ```

+ Exécutez votre programme.

+ Que se passe-t-il ? Expliquez.

== Tâche 2 -- `if` et `match`
<tâche-2-if-et-match>
+ Télécharger le fichier `lab-exp.zip` depuis le site et extrayez les
  fichiers `.scala` dans le répertoire `src` de votre projet. Suivez la
  procédure d'installation pour la libraire `FunGraphics` disponible sur
  le site du cours.
+ Ouvrez le programme `SimpleCalculator.scala` et exécutez-le.
+ Comprenez son fonctionnement. Pour l'instant, il ne comporte que 3
  opérations : l'addition, la soustraction et la multiplication.
  Modifiez le code source pour rajouter l'opération de division.
+ Remplacez les tests `if` par un opérateur `match`.
+ Rajoutez maintenant une nouvelle option dans votre programme, qui va
  afficher les deux nombres en binaire, mais sans passer par l'opérateur
  `toBinaryString`. Le principe est de lire les bits du chiffre un après
  l'autre et de les afficher, grâce à une boucle. Pour ne lire que le
  premier bit, il faut faire un masque qui ne conserve que le premier
  bit (calculer un AND avec le nombre binaire 1). Ensuite, il faut
  décaler le nombre et continuer à le faire tant que nous n'avons pas
  parcouru tous les bits.
+ Rajouter une boucle qui englobe tout le programme, afin de répéter
  toutes les opérations.
+ Rajouter maintenant une condition qui permette de sortir de la boucle
  quand on le désire. Pour cela, rajoutez un nouvel opérateur dans la
  liste des opérateurs, nommé #emph[quit] et qui, lorsqu'il est
  sélectionné, quitte la boucle. Pour ce faire, réfléchissez à comment
  influencer la condition de la boucle.

= Partie 2 - Exemples simples utilisant la classe FunGraphics
<partie-2---exemples-simples-utilisant-la-classe-fungraphics>
La classe `FunGraphics` se charge de vous fournir une surface graphique
sur laquelle vous pouvez dessiner librement. Après avoir installé la
librairie comme indiqué au début de ce labo, testez maintenant
l'ouverture d'une fenêtre de taille #emph[width x height] se réalise à
l'aide du code suivant:

```scala
val display: FunGraphics = FunGraphics(width, height)
```

La librairie graphique permet contient plusieurs méthodes de dessin
différentes mais nous allons commencer simplement à l'aide de la méthode
`display.setPixel(x:Int, y:Int)` qui fait apparaître un point à la
position (x, y). Attention, la position (0,0) se trouve en haut à gauche
de l'écran comme indiqué sur la figure asdf\@fig:fig\_coords.

#figure(image("figs/dessin_ecran.png", height: 5cm,),
  caption: [
    Figure 1: Coordonnées dans la fenêtre graphique
  ]
)
<fig:fig_coords>

#quote(block: true)[
Lorsque vous ajoutez une variable de type `FunGraphics`, #emph[IntelliJ]
va rajouter automatiquement la ligne `import hevs.graphics.FunGraphics`,
qui indique que nous utilisons quelque chose provenant d'un autre
ficher.
]

== Tâche 3 -- Dessin d'une flèche
<tâche-3-dessin-dune-flèche>
+ Ouvrez le fichier `DrawArrow.scala` et exécutez le programme. Il va
  créer une fenêtre graphique et dessiner un carré noir composé de 9
  pixels centré en position \[150,100\].

+ Codez maintenant un programme qui va dessiner une flèche horizontale
  qui pointe à droite, avec une longueur de 100 pixels et une tête de 20
  pixels, comme dans le dessin de la figure . Il vous faudra utiliser
  plusieurs boucles et utiliser la méthode `setPixel()`.

  + Dessinez d'abord le trait horizontal du corps de la flèche avec une
    boucle.
  + Dans un deuxième temps, dessinez chaque branche de la flèche à
    l'aide d'une boucle.

  #figure(image("figs/arrow.svg", height: 2.5cm),
    caption: [
      Dessin de la flèche
    ]
  )

== Tâche 4 -- Dessin d'un rectangle
<tâche-4-dessin-dun-rectangle>
Nous allons maintenant travailler un peu avec de la couleur. Pour ce
faire, rajoutez la ligne `import java.awt.Color` au dessus du début de
votre programme.

+ Créez une nouvelle classe `Task4` basée sur le modèle ci-dessus avec
  une fenêtre graphique

+ Écrivez maintenant un code qui va dessiner un rectangle plein, bleu,
  centré en position \[200,200\], d'une largeur de 300 pixels et d'une
  hauteur de 200 pixels.

  #quote(block: true)[
  L'idée pour dessiner le rectangle est d'utiliser deux boucles
  imbriquées qui vont balayer les pixels correspondants au rectangle et
  qui vont les peindre avec la bonne couleur.
  ]

+ Pour peindre le pixel en position \[x,y\] en bleu, vous pouvez
  utiliser la méthode suivante :

  ```scala
  display.setPixel(x, y, Color.blue)
  ```

== Tâche 5 -- Dégradé rouge-bleu
<tâche-5-dégradé-rouge-bleu>
+ Faites une nouvelle classe avec une interface graphique.

+ La fenêtre graphique créée doit faire 256 pixels par 256 pixels.

+ Le but de cet exercice est de dessiner une palette d'un dégradé de
  couleurs bleu et rouge, comme sur la figure . Pour ce faire, il faut
  utiliser une première boucle pour faire le dégradé horizontal de rouge
  et une seconde, imbriquée dans la première, pour faire le dégradé
  vertical.

+ Si un pixel est à la position \[x,y\], on va le peindre avec une
  valeur de bleu de `y` et une valeur de rouge de `x`. La valeur verte
  du pixel restant toujours à zéro.

+ Pour peindre le pixel en position \[x,y\] d'une certaine couleur, on
  utilise ainsi:

  ```scala
  display.setPixel(x, y, new Color(RED, GREEN, BLUE))
  ```

  #quote(block: true)[
  Dans une couleur dans ce modèle, on décrit la couleur finale en
  fonction des composantes RED, GREEN et BLUE. Dans notre cas, ce sont
  des valeurs entières entre 0 et 255. La valeur 0 signifie qu'une
  composante de la couleur est absente, tandis que 255 signifie que la
  couleur est à son intensité maximale. On peut en mélangeant ces
  couleurs de bases réaliser toutes sortes de couleurs.
  ]

  #figure(image("figs/colors.png", height: 5.0cm),
    caption: [
      Dessin du dégradé de couleurs
    ]
  )

+ Combien de couleurs #strong[différentes] peut-on obtenir avec le
  système décrit ci-dessus ?

== Tâche 6 -- Dessin d'un disque
<tâche-6-dessin-dun-disque>
+ Écrivez maintenant un code qui va créer une fenêtre graphique et y
  dessiner un disque bleu rempli, centré en position \[200,200\] et d'un
  rayon de 100 pixels, sur fond rouge.
+ Une possibilité pour résoudre ce problème et de créer deux boucles qui
  vont balayer tous les pixels de l'image, les peindre en bleu s'ils
  sont dans le disque (remplissent la condition de distance par rapport
  au centre du cercle) et en rouge sinon.

== Tâche 7 -- Lemniscate
<tâche-7-lemniscate>
Le lemniscate de Bernoulli est une courbe mathématique dont le tracé est
le suivant :

#figure(image("figs/lemniscate.png", height: 3.0cm),
  caption: [
    Un lemniscate de Bernoulli
  ]
)

+ Dessinez cette courbe dans laquelle les coordonnées `x` et `y` qui se
  trouvent sur la courbe sont donnés par l'équation paramétrique
  suivante (#emph[a] est une constante) :
  $ cases(delim: "{", x (t) & = a frac(sin t, 1 + cos^2 t), y (t) & = a frac(sin t cos t, 1 + cos^2 t), ) $

+ Quel est l'effet de $a$ dans le jeu d'équation ci-dessus ?

+ #strong[\[Optionnel\]] Affichez le dessin de manière animée afin de
  voir la variation de `t` avec le temps.

/**
 * EPILOGUE - After the body
 **/

// This is the end