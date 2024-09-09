= Evaluation <section_evaluation>

In this chapter, the results of the experiment are evaluated and compared with those of a monolithic architecture using a single-page application (SPA). The decision to use the monolithic @spa approach for comparison stems from its close alignment with the experiment’s solution, as both rely on client-side composition and routing. Additionally, MULTA MEDIO is currently working on another rewrite project for a lottery platform using the same monolithic @spa version, which already offers several advantages. This consistency provides developers within the organization with a unified perspective. It is also worth noting that the @spa version is essentially a simplified adaptation of the micro frontends version.

Following this comparison, the four key aspects affected by adopting micro frontend architecture, as they relate to the first research question, are discussed.

The source code for both the micro frontends and monolithic versions is available in the repositories @nguyen_DKLB_2024 and @nguyen_DKLB_Monolith_2024.

== Comparison of Development Cycle

The table below outlines the key differences in the development cycle between the micro frontend and monolithic @spa approaches.

#{
  show table.cell.where(x: 0): strong
  show table.cell.where(y: 0): strong
  let flip = c => table.cell(align: horizon, rotate(-90deg, reflow: true)[#c])
  
  table(
    columns: (auto, 1fr, 1fr),
    inset: 10pt,
    align: (top, left),
    table.header([], align(center, [Micro frontends]), align(center, [Monolithic SPA])),
    
    flip[Setup Stage],
    [
      Although the project structure of micro frontends is organized to ensure a clear overview, it remains complex due to the presence of numerous directories.
      
      All remotes, the host application, and the UI library must be properly configured to ensure seamless integration.

      Managing dependencies between micro frontends introduces additional complexities.
    ],
    [ 
      The directories `apps`, `packages`, and `tools` mentioned in @figure_project_structure are redundant. Instead, a single `app` directory is used to store the entire frontend.
      
      Both dependency management and configurations are simplified, as the application utilizes a single `package.json` file for all dependencies and a single `vite.config.ts` file for all configurations.
    ], 
    
    flip[Implementation Stage],  
    table.cell(colspan: 2)[
       As discussed in @section_implementation, Module Federation with client-side composition offers a development experience similar to that of the @spa approach, leading to comparable implementations for both the host and remote applications in each method.  
       
       However, the routing challenges and the integration of the UI library encountered in the micro frontend version are significantly easier to manage in the @spa version.
    ],
  
    flip[Build Stage],   
    [
      The UI library must be built first before the host and remote applications can be successfully bundled. 
      
      The process of building the server application remains identical in both approaches.
    ],
    [
      No special considerations are necessary, as the entire frontend can be built in a single process.
    ],
    
    flip[Testing Stage],
    table.cell(colspan: 2)[
      Unit testing and end-to-end testing are the same for both approaches. Unit testing occurs at the component level, while end-to-end testing primarily simulates user interactions in a real browser environment. Both types of testing focus on verifying functionality and user workflows, rather than on how components are composed into the view.
    ],
    
    flip[Deployment Stage],
    [ 
      Deployment with micro frontends is more complex, as it necessitates the creation of key configuration files depending on the number of applications involved. However, the more effort invested during this stage, the less work will be required in the CI/CD process.
    ], 
    [ 
       The configuration files can be written once and require minimal modifications thereafter, as there will consistently be two applications running in parallel: the frontend and the server application.
    ],
    
    flip[CI Stage],
    [ 
      The number of configuration files for CI increases with the number of micro frontends.
      
      However, only the pipeline responsible for a specific micro frontend will be triggered when changes are made to that micro frontend.
    ], 
    [ 
      The CI steps are mostly identical in both approaches. But in @spa approach, having a single configuration file for CI results in a shorter pipeline runtime.
      
      However, as any modification in any part of the application will trigger the pipeline for the entire application.
    ],
    
    flip[CD Stage],
    table.cell(colspan: 2)[
     The CD pipeline is identical for both approaches, with each configured to run after code changes are merged into the main branch, triggering redeployment on the virtual private server.
    ],
  )  
}

== Impact on Flexibility, Maintainability, Scalability, and Performance

Based on the results of the experiment, this section will discuss how these four aspects of a web application are impacted by adopting micro frontend architecture.

=== Flexibility

The `home` and `lotto` micro frontends offer the flexibility to use different dependencies during development. For example, the `home` micro frontend can use `zod` for schema validation, while the `lotto` micro frontend can utilize `valibot`. Furthermore, if a new frontend framework is chosen in the future to replace Vue.js, it can be applied incrementally in the `home` application, while the `lotto` application continues using Vue.js, ensuring that the overall functionality of the application remains unaffected during the transition.

Additionally, new features or patches can be quickly applied at runtime without disrupting the other. If, during an update, the updated micro frontend becomes temporarily unavailable, the host application will detect the issue and navigate the user to an error page, providing clear and appropriate information about the disruption.

However, this flexibility introduces complexity in maintaining unified functionality across micro frontends, as different libraries may not behave consistently. Additionally, if the choice of a UI library is not carefully planned from the planning stage, the application may suffer from inconsistent styling. These drawbacks can result in a poor user experience.

=== Maintainability

The frontend is divided into `home` and `lotto` modules, with each module located in its directory. This modular structure simplifies the management and maintenance of the overall system by allowing developers to focus on specific micro frontends without needing to understand the entire application. This approach makes onboarding new developers more efficient, as they can work on individual components without having to grasp the full scope from the beginning. It also reduces the likelihood of introducing unintentional bugs or inconsistencies when making changes.

This separation, though beneficial, can result in redundancy in certain areas. For instance, shared logic, such as the fetch function used to retrieve gaming history quotes, might be duplicated across multiple micro frontends, which violates the DRY (Don't Repeat Yourself) principle. Additionally, maintaining consistency becomes more challenging, as refactoring or updating shared logic may not always be synchronized across all micro frontends. This can lead to a potential lack of similarity and increased maintenance efforts over time.

=== Scalability

If the `lotto` module experiences a surge in traffic, it can be scaled independently, optimizing resource usage by ensuring that only the necessary parts of the system receive additional resources. The team responsible for this micro frontend can tailor the scaling strategy based on its specific workload or user interaction patterns, allowing for a more efficient and responsive system.

Independent scaling can introduce increased infrastructure overhead. Each micro frontend may require its own hosting and monitoring, which adds complexity and raises operational costs. Additionally, common backend services, such as databases, may become bottlenecks if not properly optimized to handle the demands of independently scaled micro frontends. This can result in performance issues that impact the entire application, despite the modularity of the frontend components.

=== Performance

Since each micro frontend operates as an independent module, only the necessary parts of the application are loaded at any given time. For instance, when a user interacts with the `lotto` module, only the relevant components for that module are fetched, while the code chunks for the `home` module remain untouched. This approach not only improves initial page load times but also ensures that users only download essential parts of the application, reducing latency and enhancing overall responsiveness.

Integrating multiple independent micro frontends, however, introduces additional complexity. Ensuring efficient communication between these modules, especially when shared resources or data are involved, requires careful planning and optimization to avoid performance bottlenecks.

To further evaluate performance, the open-source tool Sitespeed.io is used to analyze website speed based on performance best practices @_SiteSpeedIO_. The table below provides a comparison between the micro frontends and @spa versions, with metrics measured using the Chrome browser over five iterations. The results are color-coded: blue indicates informational data, green denotes a pass, yellow signals a warning, and red represents poor performance.

#{
  let tred = c => text(weight: "bold", fill: red, c)
  let tgreen = c => text(weight: "bold", fill: green, c)
  let tblue = c => text(weight: "bold", fill: blue, c)
  let tyellow = c => text(weight: "bold", fill: rgb(225,164,0), c)
  show table.cell.where(y: 0): strong
  show table.cell.where(x: 0): strong
  
  figure(
    caption: [Comparison between the micro frontends and monolithic SPA versions.],
    table(
      columns: (1.5fr, 1fr, 1fr),
      inset: 10pt,
      align: left,
      table.header([], [Micro frontends], [Monolithic SPA]),
      [First Contentful Paint],     tgreen[60 ms],    tgreen[44 ms],
      [Fully Loaded],               tblue[80 ms],     tblue[58 ms],
      [Page Load Time],             tblue[7 ms],      tblue[16 ms],
      [Largest Contentful Paint],   tgreen[185 ms],   tgreen[168 ms],
      [Total Requests],             tgreen[26],       tgreen[15],
      [JavaScript Requests],        tblue[15],        tblue[6],
      [CSS Requests],               tblue[3],         tblue[1],
      [HTML Transfer Size],         tblue[563 B],     tblue[458 B],
      [JavaScript Transfer Size],   tred[299.6 KB],   tyellow[143.3 KB],
      [CSS Transfer Size],          tblue[24.2 KB],   tblue[16.8 KB],
      [Total Transfer Size],        tgreen[333.3 KB], tgreen[167.8 KB],  
    ),
  )
}
#v(1em)

An important metric to consider is the JavaScript Transfer Size, which accounts for approximately 85-90% of the Total Transfer Size. In the micro frontends implementation, this transfer size is nearly double that of the @spa version, leading to longer page load times. The primary reason for this increase is the requirement for the host application to fetch the `remoteEntry.js` files from its remote modules. These entry files play a crucial role in Module Federation, containing essential information about the remote module, such as its name and the components it exposes @_ModuleFederation_. This additional overhead can slow down the initial load, as the host must retrieve and process these files to properly display the micro frontends and manage their interactions.

== Limitations

Due to the limited scope of the experiment, the implemented application remains relatively small, making it challenging to fully evaluate the advantages of micro frontend architecture in a large-scale web application. This smaller scale also accounts for why the monolithic @spa, which is generally more efficient for smaller projects, outperformed the micro frontend version in terms of performance. Additionally, the experiment concentrated on a single approach to implementing micro frontends, leaving several important aspects unexplored. For example, the potential benefits of using native Web Components instead of Module Federation were not examined, nor was the impact of integrating Module Federation with server-side composition. These unexplored alternatives could offer valuable insights into how micro frontends may function in different scenarios and when scaling for larger, more complex applications.

#pagebreak(weak: true)
