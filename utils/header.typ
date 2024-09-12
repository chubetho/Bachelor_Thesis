#let buildMainHeader(mainHeading) = {
  [
    #text(mainHeading.body)
    #line(length: 100%, stroke: 0.5pt)
  ]
}

#let buildSecondaryHeader(mainHeading, secondaryHeading) = {
  [
    #text(mainHeading.body)
    #h(1fr)
    #context (counter(heading).display())
    #text(secondaryHeading.body)
    #line(length: 100%, stroke: 0.5pt)
  ]
}

// To know if the secondary heading appears after the main heading
#let isAfter(secondaryHeading, mainHeading) = {
  let secHeadPos = secondaryHeading.location().position()
  let mainHeadPos = mainHeading.location().position()
  if (secHeadPos.at("page") > mainHeadPos.at("page")) {
    return true
  }
  if (secHeadPos.at("page") == mainHeadPos.at("page")) {
    return secHeadPos.at("y") > mainHeadPos.at("y")
  }
  return false
}

#let getHeader() = {
  locate(loc => {
    // Find if there is a level 1 heading on the current page
    let nextMainHeading = query(selector(heading).after(loc), loc).find(headIt => {
      headIt.location().page() == loc.page() and headIt.level == 1
    })
    if (nextMainHeading != none) {
      return buildMainHeader(nextMainHeading)
    }
    // Find the last previous level 1 heading -- at this point surely there's one :-)
    let lastMainHeading = query(selector(heading).before(loc), loc)
      .filter(headIt => {
          headIt.level == 1
        })
      .last()
    // Find if the last level > 1 heading in previous pages
    let previousSecondaryHeadingArray = query(selector(heading).before(loc), loc).filter(headIt => (
      headIt.level > 1
    ))
    let lastSecondaryHeading = if (previousSecondaryHeadingArray.len() != 0) {
      previousSecondaryHeadingArray.last()
    } else {
      none
    }
    // Find if the last secondary heading exists and if it's after the last main heading
    if (
      lastSecondaryHeading != none and isAfter(
        lastSecondaryHeading,
        lastMainHeading,
      )
    ) {
      return buildSecondaryHeader(lastMainHeading, lastSecondaryHeading)
    }
    return buildMainHeader(lastMainHeading)
  })
}
