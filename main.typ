#import "@preview/glossarium:0.4.1": make-glossary
#import "utils/header.typ": getHeader

#set document(
  title: "A Study on Micro Frontend Architecture and Its Impact", 
  author: "Tan Phat Nguyen"
)

#set text(font: "New Computer Modern Sans", lang: "en", size: 12pt)

#include "templates/cover.typ"

#show: make-glossary

#set par(justify: true)
#set align(top + left)
#set page(
  margin: (right: 3cm, left: 3cm, top: 4cm, bottom: 4cm),
  header: getHeader(),
  numbering: "i"
)

#include "templates/abstract.typ"

#set outline(indent: true, fill: repeat("  .  "))

#show (heading): it => [
  #if(it.level == 1){
    set text(24pt)
    v(1em)
    it
    v(1em)
  }else{
    v(1.5em)
    it
    v(0.75em)
  }
]

#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 12pt,
  radius: 4pt,
  width: 100%
)

#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (top: 1.5pt, bottom: 1.5pt, left: 3pt, right: 3pt),
  radius: 2pt,
  baseline: 10%
)

// #show figure.caption: it => [#text(size: 0.95em)[#it]]

#show figure.where(kind: raw): it => [
  #align(left)[#it.body]
  #align(center)[#it.caption]
  #v(1em)
]

#show outline.entry.where(level: 1): it => {
  v(16pt, weak: true)
  link(it.element.location(), strong({
    it.body
    h(1fr)
    it.page
  }))
}

#set quote(block: true)

#include "templates/toc.typ"

#include "templates/glossary.typ"

#include "templates/figures.typ"

#include "templates/listings.typ"

// #include "templates/tables.typ"

#set page(numbering: "1")
#counter(page).update(1)
#set heading(numbering: "1.")

#include "chapters/introduction.typ"

#include "chapters/background.typ"

#include "chapters/research.typ"

#include "chapters/fundamental.typ"

#include "chapters/approaches.typ"

#include "chapters/experimental.typ"

#include "chapters/conclusion.typ"

#include "chapters/summary.typ"

#include "templates/declaration.typ"

#include "templates/confirmation.typ"

#include "templates/bibliography.typ"