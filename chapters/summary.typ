= Summary

In this concluding chapter, the insights from @section_review and the key findings from the evaluation chapters are synthesized to address the two primary research questions of this study. Subsequently, a plan for future research is proposed to further explore and enhance the feasibility of adopting a micro frontend architecture for the @dklb project.

== Conclusion

A table outlining the advantages and disadvantages across the four aspects of flexibility, maintainability, scalability, and performance will be presented first.

#{
  show table.cell.where(x: 0): strong
  show table.cell.where(y: 0): strong
  show table.cell.where(y: 0): set align(center)
  let flip = c => table.cell(align: horizon, rotate(-90deg, reflow: true)[#c])

  table(
    columns: (auto, 1fr, 1fr),
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
    ],
  )
}

The table above indicates that a micro frontend architecture can effectively address the challenges and limitations of the current monolithic system in the @dklb project. This approach introduces greater flexibility in development and deployment, while also improving maintainability and scalability for individual parts of the frontend. These characteristics align well with agile methodologies, promoting iterative development and enabling faster delivery. Moreover, as highlighted in the research by Männistö et al., even small teams can leverage the benefits of this architecture provided @mannisto_ExperiencesFrameworklessMicroFrontend_2023.

However, adopting a micro frontend architecture introduces additional complexity in management and monitoring, particularly in ensuring smooth integration of components and a consistent user experience. Additionally, the decentralized nature of this approach requires further optimization to maintain adequate performance levels.

In conclusion, micro frontend architecture presents a promising solution for large-scale web applications, delivering notable advantages while also introducing certain challenges. The decision to implement this approach should be driven by the project's specific requirements, carefully considering whether the additional complexities are justified by the benefits. While this study has examined crucial aspects of the web application development process, further in-depth analysis is necessary to fully assess and optimize its potential for the @dklb project.

== Future Research

One necessary optimization is bundle analysis, which aims to reduce duplicate code by ensuring proper sharing of library code across JavaScript chunks, as these redundancies can negatively impact performance. To address this issue, gaining deeper knowledge of the Vite plugin could enable more precise intervention in its configuration.

Alternatively, Rspack could be considered as a replacement bundler, given its official support for Module Federation. This provides a key advantage over Vite, which currently depends on a third-party plugin that is no longer actively maintained. Furthermore, the case for adopting Rspack is strengthened by its collaboration with the creator of Module Federation on the forthcoming release of Module Federation 2.0. This update promises new features, expanded use cases, and improved performance, making it a more robust solution.

Additionally, improved error-handling mechanisms should be implemented. For example, when a horizontal micro frontend encounters an error, redirecting the user to an error page disrupts the experience, as only a portion of the view may be affected. A more refined approach would involve updating the overview configuration at runtime to control which micro frontends are displayed or hidden, allowing for greater flexibility and enabling more dynamic solutions.

#pagebreak(weak: true)