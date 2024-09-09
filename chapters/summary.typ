= Summary

In this concluding chapter, the insights from @section_review and the key findings from the evaluation chapters are synthesized to address the two primary research questions of this study. Subsequently, a plan for future research is proposed to further explore and enhance the feasibility of adopting a micro frontend architecture for the @dklb project.

== Conclusion

// - RQ1: How does adopting micro frontend architecture specifically affect the flexibility, maintainability, scalability, and performance of a web application?

A table outlining the advantages and disadvantages across the four aspects of flexibility, maintainability, scalability, and performance will be presented first.

#{
  show table.cell.where(x: 0): strong
  show table.cell.where(y: 0): strong
  show table.cell.where(y: 0): set align(center)
  let flip = c => table.cell(align: horizon, rotate(-90deg, reflow: true)[#c])

  table(
    columns: (auto, 1fr,1fr),
    inset: 10pt,
    [], [Advantages], [Disadvantages],
 
    flip[Flexibility],
    [
      Independent development and deployment of frontend components, reducing downtime and enabling parallel work.
    ],
    [
      Introduces added complexity, particularly in maintaining consistent functionality and ensuring a seamless user experience across the different micro frontends.
    ],

    flip[Maintainability],
    [
      Smaller, modular codebases improve maintainability, making it easier to manage, and onboard new developers.
    ],
    [
      Managing multiple repositories or codebases can lead to fragmented maintenance efforts and potential duplication.
    ],

    flip[Scalability],
    [
      Enables independent scaling of specific frontend components, optimizing resource usage. 
    ],
    [
      Potential for increased infrastructure overhead, as each micro frontend may require separate hosting and monitoring.
    ],
    
    flip[Performance], 
    [
      More efficient loading, with the possibility to load only necessary parts of the application, improving user experience.
    ],
    [
      Initial setup may be complex, with potential performance challenges around integration and communication between micro frontends.
    ]
  )
}

// - RQ2: Can the micro frontend approach effectively mitigate the specific challenges and limitations inherent in the current monolithic architecture of the @dklb project?

The table above highlights that a micro frontend architecture can effectively address the challenges and limitations of the current monolithic system in the @dklb project. This approach introduces greater flexibility in development and deployment, while also improving maintainability and scalability for individual parts of the frontend. These characteristics align well with agile methodologies, promoting iterative development and enabling faster delivery.

However, adopting a micro frontend architecture introduces additional complexity in management and monitoring, particularly in ensuring the seamless integration of components. The decentralized nature of this approach also necessitates further optimization to maintain satisfactory performance levels.

In conclusion, micro frontend architecture offers a promising solution for large-scale web applications, providing significant benefits while presenting certain challenges. The decision to adopt this approach should be guided by the specific needs of the project, ensuring that the added complexities do not outweigh the advantages. In the case of the @dklb project, micro frontends represent a viable solution. Although this study has addressed key aspects of the web application development cycle, further detailed investigation is required to fully explore and optimize its potential.

== Future Research

One necessary optimization is bundle analysis, which focuses on reducing duplicate code across JavaScript chunks, as these redundancies can negatively impact performance. To address this issue, gaining deeper knowledge of the Vite plugin could enable more precise intervention in its configuration, or Rspack could be used as a replacement bundler due to its official support for Module Federation. This offers a significant advantage over Vite, which, at the time of writing, relies on a third-party plugin that is no longer actively maintained. The decision to adopt Rspack is further supported by its collaboration with the creator of Module Federation on the upcoming release of Module Federation 2.0, which promises new features, broader use cases, and enhanced performance.

Additionally, improved error-handling mechanisms should be implemented. For example, when a horizontal micro frontend encounters an error, redirecting the user to an error page disrupts the experience, as only a portion of the view may be affected. A more refined approach would involve updating the overview configuration at runtime to control which micro frontends are displayed or hidden, allowing for greater flexibility and enabling more dynamic solutions.

#pagebreak(weak: true)