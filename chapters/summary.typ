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
      *Technology Agnostic*: Teams can choose different technologies or frameworks that best suit their micro frontend, enabling the adoption of new technologies without rewriting the entire application.

      *Independent Deployment*: Micro frontends can be deployed independently, allowing for faster feature releases and rollbacks.
    ],
    [
      *Inconsistent User Interface:* Without strict guidelines, the look and feel across micro frontends can become inconsistent, affecting the overall user experience.
      
      *Integration Challenges:* Combining different technologies and frameworks requires careful planning to ensure seamless interaction between micro frontends.
    ],

    flip[Maintainability],
    [
      *Modular Codebase*: Breaking the frontend into smaller, manageable pieces makes the codebase easier to understand and maintain. Each team can focus on a specific module without affecting others.
      
      *Independent Updates*: Teams can update or refactor their micro frontend without coordinating with other teams, reducing the risk of introducing bugs into unrelated parts of the application.
      
      *Isolation of Issues*: Bugs are confined to specific micro frontends, making it easier to locate and fix problems.
    ],
    [
      *Complex Dependency Management:* Managing shared libraries and ensuring consistency across micro frontends can become challenging.
      
      *Overhead in Tooling:* Maintaining multiple build processes, repositories, or deployment pipelines can increase the complexity of the development environment.
    ],

    flip[Scalability],
    [
      *Team Scalability*: Multiple teams can work in parallel on different micro frontends without interfering with each other, enhancing productivity.
      
      *Performance Scaling*: Specific micro frontends can be scaled independently based on load and performance needs, optimizing resource usage.
      
      *Modular Growth*: New features can be added as separate micro frontends without impacting the existing system.
    ],
    [
      *Infrastructure Complexity:* Scaling multiple micro frontends may require sophisticated infrastructure and orchestration tools.
      
      *Network Overhead*: Increased number of services can lead to more network requests, which might impact performance if not managed properly.
    ],

    flip[Performance],
    [
      *Optimized Loading:* Micro frontends allow for lazy loading of components, reducing initial load times by fetching only what's necessary.
    ],
    [
      *Increased Bundle Size*: Different micro frontends might include duplicate dependencies, increasing the overall application size.
      
      *Runtime Overhead:* Assembling multiple micro frontends at runtime can introduce latency, especially if not efficiently managed.
    ],
  )
}

The table above indicates that a micro frontend architecture can effectively address the challenges and limitations of the current monolithic system in the @dklb project. This approach introduces greater flexibility in development and deployment, while also improving maintainability and scalability for individual parts of the frontend. These characteristics align well with agile methodologies, promoting iterative development and enabling faster delivery. Moreover, as highlighted in the research by Männistö et al., even small teams can leverage the benefits of this architecture provided @mannisto_ExperiencesFrameworklessMicroFrontend_2023.

However, adopting a micro frontend architecture introduces additional complexity in management and monitoring, particularly in ensuring a smooth integration of components and a consistent user experience. Additionally, the decentralized nature of this approach requires further optimization to maintain adequate performance levels.

In conclusion, micro frontend architecture presents a promising solution for web applications, delivering notable advantages while also introducing certain challenges. The decision to implement this approach should be driven by the project's specific requirements, carefully considering whether the additional complexities are justified by the benefits. While this study has examined crucial aspects of the web application development process, further in-depth analysis is necessary to fully assess and optimize its potential for the @dklb project.

== Future Research

One necessary optimization is bundle analysis, which aims to reduce duplicate code by ensuring proper sharing of library code across JavaScript chunks, as these redundancies can negatively impact performance. To address this issue, gaining deeper knowledge of the Vite plugin could enable more precise intervention in its configuration.

Alternatively, Rspack could be considered as a replacement bundler, given its official support for Module Federation. This provides a key advantage over Vite, which currently depends on a third-party plugin that is no longer actively maintained. Furthermore, the case for adopting Rspack is strengthened by its collaboration with the creator of Module Federation on the forthcoming release of Module Federation 2.0. This update promises new features, expanded use cases, and improved performance, making it a more robust solution.

Additionally, improved error-handling mechanisms should be implemented. For example, when a horizontal micro frontend encounters an error, redirecting the user to an error page disrupts the experience, as only a portion of the view may be affected. A more refined approach would involve updating the overview configuration at runtime to control which micro frontends are displayed or hidden, allowing for greater flexibility and enabling more dynamic solutions.

#pagebreak(weak: true)