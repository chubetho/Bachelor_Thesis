= Evaluation

In this chapter, the results of the experiment are evaluated and compared with the outcomes of a monolithic architecture using a single-page application (SPA). Following this comparison, the advantages and disadvantages of the microfrontend architecture will be thoroughly discussed.

== Comparison with Monolithic SPA

The decision to employ the @spa approach for comparison is guided by its strong alignment with the solution utilized in the experiment, particularly since both approaches depend on client-side composition and routing. Additionally, MULTA MEDIO is currently engaged in another rewrite project for a lottery platform using the same monolithic @spa version, which offers several advantages. This consistency allows developers within the organization to maintain a unified perspective. The @spa version is, in fact, an adaptation of the microfrontends version, though with some reductions. The following table will highlight the differences in the software lifecycle between these two approaches, alongside the collection of relevant metrics for further analysis.

The source code for both the microfrontends and monolithic versions is available in the repositories @nguyen_DKLB_2024 and @nguyen_DKLB_Monolith_2024.

=== Software Lifecycle
#{
  show table.cell.where(x: 0): strong
  show table.cell.where(y: 0): strong
  let flip = c => table.cell(align: horizon, rotate(-90deg, reflow: true)[#c])
  
  table(
    columns: (auto, 1fr, 1fr),
    inset: 10pt,
    align: (top, left),
    table.header([], align(center, "Microfrontends"), align(center, "SPA")),
    
    flip[Setup Stage],
    [
      While the project structure of microfrontends is organized to maintain a clear overview, it remains complex. Managing dependencies between microfrontends presents additional challenges. 
      
      Furthermore, it is important to correctly configure all remotes, the host application, and the UI library to ensure seamless integration.
    ],
    [ 
      The directories `apps`, `packages`, and `tools` mentioned in @figure_project_structure are redundant in this context. Instead, a single `app` directory should be created to store the entire frontend. 
      
      This simplifies both dependency management and configuration, as it requires only one `package.json` and `vite.config.ts` file for the application.
    ], 
    
    flip[Implementation Stage],  
    table.cell(colspan: 2)[
      As outlined in @section_implementation, Module Federation with client-side composition provides a development experience comparable to that of @spa, resulting in similar implementations for the host and remote applications in both approaches. 
      
      Additionally, unlike the microfrontends version, there is no need for @spa version to configure the UI library for separate builds. Additionally, the routing challenges encountered in the microfrontends version are significantly easier to resolve in the @spa version.
    ],
  
    flip[Build Stage],   
    [
      The UI library must be built first before the host and remotes application can be successfully built. 
      
      The process of building the server application is the same in both approaches.
    ],
    [
      There is no special considerations are necessary since the entire frontend can be built in a single process. 
    ],
    
    flip[Testing Stage],
    table.cell(colspan: 2)[
      Unit testing and end-to-end testing are identical for both approaches. Unit testing occurs at the component level, while end-to-end testing primarily simulates user interactions within a real browser environment. Both types of testing focus on functionality and user's workflows rather than on how components are composed into the view.
    ],
    
    flip[Deployment Stage],
    [ 
      Deployment with microfrontends is more complex, requiring the creation of crucial configuration files based on the number of applications involved. However, the more effort invested here, the less work will be required in the CI/CD stage.
    ], 
    [ 
      The configuration files can be written once and require minimal changes thereafter, as there will always be two applications running alongside each other: the frontend and the server application.
    ],
    
    flip[CI Stage],
    [ 
      The number of configuration files for CI increases with the number of microfrontends. This will extend but also reduce the runtime of the CI pipelines. As only the pipeline responsible for a specific microfrontend will be triggered when changes are made to that microfrontend.
    ], 
    [ 
     The CI steps are mostly identical in this approach. However, having a single configuration file for CI leads to a shorter pipeline runtime compared to the microfrontends approach. Nonetheless, any change in any part of the application will trigger the pipeline for the entire application. 
    ],
    
    flip[CD Stage],
    table.cell(colspan: 2)[
      The CD pipeline is the same for both approaches, with each configured to run after code changes are pushed to the main branch, triggering redeployment on the virtual private server.
    ],
  )  
}

=== Measure Metrics

1. CI Pipelines Metrics

To further clarify the comparison of CI stages mentioned earlier, the following metrics show the pipeline runtimes for both approaches. Although the microfrontends version includes a separate pipeline for the UI library, the overall runtimes for all applications in both approaches remain comparable. This is because each pipeline in the microfrontends version must build its own UI library. The observed 30-second difference in the end-to-end testing phase is due to the microfrontends approach, which requires four separate build processes before testing can proceed, compared to the single build needed in the @spa approach.

#{
  show table.cell.where(y: 0): smallcaps
  show table.cell.where(y: 0): strong
  show table.cell.where(y: 3): strong
  set table.hline(stroke: 0.75pt)

  grid(
    columns: (1fr, 1fr),
    gutter: 30pt,
    [
      #figure(
        caption: "Runtimes of the five pipelines in the microfrontends approach.",
        table(
          columns: (1fr,1fr,1fr,1fr,1fr),
          stroke: none,
          inset: 10pt,
          table.cell(colspan: 5)[Microfrontends],
          table.hline(),
          [shell],  [home], [lotto],  [ui],   [e2e],
          [29s],    [31s],  [30s],    [25s],  [110s],
          table.hline(),
          table.cell(colspan: 5)[Total: 225s],
        )
      )
    ],
    [
      #figure(
        caption: "Runtimes of the two pipelines in the SPA approach.",
        table(
          columns: (1fr,1fr),
          stroke: none,
          inset: 10pt,
          table.cell(colspan: 2)[SPA],
          table.hline(),
          [app],  [e2e],
          [30s],  [90s],
          table.hline(),
          table.cell(colspan: 2)[Total: 120s],
        )
      )
    ]
  )
}

2. Browser Metrics

To evaluate browser metrics, the open-source tool Sitespeed.io was employed to analyze website speed based on performance best practices @_SiteSpeedIO_. The table below provides a comparison between the microfrontends and @spa versions, with metrics measured using Chrome over five iterations. The results are color-coded: blue indicates informational data, green denotes a pass, yellow signals a warning, and red represents poor performance.

An important metric to evaluate is the JavaScript Transfer Size, which accounts for approximately 85-90% of the Total Transfer Size. In the microfrontends implementation, this transfer size is nearly double that of the single-page application (SPA) version, resulting in a longer page load time. This increase is primarily due to the need for the host application to fetch the `remoteEntry.js` files from its remote modules. This entry file contains important information, including the name of the remote module and the components it exposes through Module Federation, which are essential for rendering the user interface @_ModuleFederation_.

#{
  let tred = c => text(weight: "bold", fill: red, c)
  let tgreen = c => text(weight: "bold", fill: green, c)
  let tblue = c => text(weight: "bold", fill: blue, c)
  let tyellow = c => text(weight: "bold", fill: rgb(225,164,0), c)
  show table.cell.where(y: 0): strong
  show table.cell.where(x: 0): strong
  show table.cell.where(y: 0): smallcaps
  
  figure(
    caption: [Comparison between the microfrontends and SPA versions.],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 10pt,
      align: left,
      stroke: (_, y) => if y > 0 { (top: 0.75pt) },
      table.header([], [Microfrontends], [SPA]),
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

== Advantages and Disadvantages

#{
  show table.cell.where(y: 0): smallcaps
  show table.cell.where(y: 0): strong
  set table(align: (x, y) => if y == 0 { center } else { left })
  set table.vline(x: 1, start: 1, stroke: 0.75pt)
  set table.hline(stroke: 0.75pt)

  table(
    stroke: none,
    columns: (1fr, 1fr),
    inset: (x, y) => if (x == 0) {(top: 10pt, right: 10pt, bottom: 10pt)} else {(top: 10pt, left: 10pt, bottom: 10pt)} ,
    [Advantages],  table.vline(), [Disadvantages],

    [Smaller, independent microfrontends make the codebase easier to manage, test, and refactor.],
    [The overall system can become difficult to maintain as the number of microfrontends grows.],
    
    table.hline(),
    
    [Enables parallel development by different teams, allowing for the independent deployment of features.],
    [Introduces complexity in development and deployment processes, requiring careful coordination and a more complex pipeline.],

    table.hline(),

    [Allows the use of different technologies within the same application, optimizing individual microfrontends.],
    [Duplicates development efforts and leads to increased performance overhead due to the use of different technologies.],

    table.hline(),
    
    [Independent microfrontends increase fault tolerance, ensuring the rest of the application remains functional even if one microfrontend fails.],
    [Partial failures of independent microfrontends can confuse users and complicate troubleshooting.]
  )
}

== Limitations

Due to the limited scope of the experiment, the implemented application is relatively small, making it difficult to fully evaluate the benefits of a microfrontend architecture in a large-scale web application. Furthermore, this limited scale is also why the monolithic single-page application version, which is more suited for smaller applications, outperformed the microfrontend version. Additionally, the experiment explored only one approach to implementing microfrontends, leaving several critical aspects unexamined, such as the performance of combining Module Federation with server-side composition.

#pagebreak(weak: true)
