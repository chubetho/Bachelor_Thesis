#import "@preview/glossarium:0.4.1": gls, glspl

= Experiment <section_experiment>

In this chapter, a detailed experiment will be conducted, simulating the entire development cycle of a web application using micro frontend architecture across several stages: planning, setup, implementation, build, deployment, testing, as well as continuous integration and deployment. Each stage will be closely monitored to gather comprehensive insights into this architecture. Additionally, a single-page application version of the same application, derived from the micro frontends version, will be implemented to compare performance metrics and evaluate the overall system behavior of both approaches in the next chapter. The primary goal is to provide a deep understanding of the micro frontend approach, highlighting its potential benefits and drawbacks. Furthermore, optimizations for enhancing the developer experience will be discussed after the development cycle.

Note that the code examples presented in this chapter may differ from the actual code. For accurate and precise code, refer to the GitHub repository at @nguyen_DKLB_2024.

== Planning Stage <section_planning_stage>

In this initial stage of the experiment, the current state of the backend for the #gls("dklb", long: true) application will be briefly reviewed. Following this, each step in the decision framework outlined in the @section_decision_framework, will be applied. These steps will collectively provide valuable insights for the upcoming setup stage.

=== Backend

Fortunately, the backend architecture of the @dklb is already organized as microservices, following #gls("ddd", long: true) principles. In this context, domains such as user, games, and cart are clearly defined. For instance, the games domain is further divided into multiple core subdomains based on specific games. The `/lotto6aus49/**` path interacts exclusively with microservices dedicated to the Lotto game, while the `/eurojackpot/**` path engages with APIs associated with the Eurojackpot game. These distinct separations emphasize that each core subdomain focuses on the unique functionalities within the overall application.

However, to ensure the experiment is comprehensive, a mocked server that simulates the backend will be set up to handle requests from the micro frontends. While this server could be built using a web framework in any programming language, a JavaScript-based framework will be used to minimize additional setup efforts and maintain consistency with the frontend technologies.

=== Horizontal-Split

The principles of @ddd offer a strong foundation for implementing a vertical-split strategy for micro frontends. In this approach, each micro frontend aligns with a specific subdomain, such as a particular game, effectively mirroring the microservices architecture established on the backend.

However, to increase the system's flexibility, a horizontal-split strategy will be adopted instead. While the majority of micro frontends will continue to follow a vertical-split, focusing on specific game subdomains, certain functionalities or cross-cutting concerns will be shared across multiple micro frontends. For example, although the homepage and Lotto game are developed in separate micro frontends, the component responsible for displaying Lotto quotes can be exposed and reused within the homepage micro frontend. This adoption of a horizontal-split strategy ensures that the architecture remains adaptable and responsive to diverse requirements.

=== Module Federation

Module Federation has been chosen for its significant potential in the development process. It supports both horizontal and vertical splitting of the application, as well as client-side and server-side composition, providing the flexibility needed to accommodate future requirements with ease. Furthermore, the use of a single frontend framework across the entire application eliminates the dependency management challenges typically encountered with Module Federation, making it an even more advantageous choice.

In this experiment, client-side composition will be chosen because the potential development teams at MULTA MEDIO are already familiar with @spa development. Additionally, if the application later requires enhanced @seo, faster load times, or improved performance, transitioning from client-side to server-side composition will be straightforward, given that Module Federation already supports this capability. Further details regarding client-side routing will be discussed during the implementation stage.

For enabling communication between micro frontends, any methods outlined in @fundamental_communication will be effective. These methods can be easily opted in or out, without the need for upfront planning.

== Setup Stage

The setup stage will concentrate on selecting the appropriate tools and technologies required for the new frontend architecture. This involves choosing frameworks and libraries, as well as setting up deployment environments, and defining the project structure.

=== Tools for Development

- Vue.js: It is a progressive JavaScript framework used for building user interfaces. It is highly adaptable, supporting the creation of both simple and complex applications through its reactive and component-based architecture. This design facilitates the development of a modular and scalable frontend @_VueJS_.

- Tailwind CSS: It is a utility-first CSS framework designed to facilitate the rapid development of custom user interfaces. By utilizing utility classes, it enables developers to style elements efficiently, minimizing the need for extensive custom CSS and preventing CSS class collisions, particularly in the context of micro frontend architecture. This methodology results in cleaner, more maintainable code, aligning well with Vue.js's modular structure @_TailwindCSS_.

- Vite: It is a modern build tool that significantly enhances the development experience. It provides a fast and efficient setup, offering features like instant server start, hot module replacement, and optimized build processes. This tool integrates seamlessly with Vue.js and Tailwind CSS, improving development speed and efficiency, making it an ideal choice for modern web projects @_Vite_. Also, there is a plugin for Vite that enables the Module Federation feature for Vite @_OriginjsVitepluginfederation_2024.

- ElysiaJS: It is a web framework that enables developers to set up routes for handling different HTTP requests, making it ideal for building Restful APIs. With its robust set of features, ElysiaJS allows for the efficient and maintainable development of applications, effectively mimicking a backend server to serve API endpoints in this experiment @_Elysia_. However, since this is primarily for simulation purposes, other web frameworks like Express.js or Fastify could also be used effectively.

=== Tools for Deployment

- Docker: It is a platform that enables developers to package applications into containers, ensuring consistency across different environments. These containers encapsulate all the necessary components, such as code, runtime, libraries, and settings, making deployment and scaling straightforward and reliable @_Docker_.

- Nginx: It is a high-performance web server and reverse proxy server known for its speed, stability, and low resource consumption. Nginx is widely used for serving static content, load balancing, and as a reverse proxy for distributing traffic across multiple servers. It is particularly favored for its ability to handle a large number of concurrent connections efficiently @_Nginx_.

- GitHub Actions: It is a powerful automation tool integrated with GitHub repositories. It allows developers to create workflows for continuous integration and continuous deployment. With GitHub Actions, the deployment process can be automated, including linting, running tests, building Docker images, and deploying, ensuring a consistent and efficient pipeline from development to production @_GitHubActions_.

=== Tools for Testing

- Vitest: It is a highly efficient testing framework built on top of Vite, designed to facilitate the writing and execution of unit tests. By utilizing Vitest, developers can ensure that each component behaves as intended, helping to maintain the overall reliability of the software @_Vitest_.

- Playwright: It is an essential tool for end-to-end testing, addressing aspects of application quality that go beyond what unit tests with Vitest can achieve by allowing for comprehensive testing of the entire application, simulating real-world user interactions across different browsers. Playwright helps to identify issues that might only arise when the entire system is in use, making it an important tool for maintaining the overall quality and stability of a web application @_Playwright_.

#pagebreak()

=== Monorepo Strategy

In software development, there are two repository strategies: monorepo and polyrepo. A monorepo architecture stores code for multiple projects using a single repository. For example, a monorepo repository contains three folders, one for a web app project, one for a mobile app project, and one for a server app project. In contrast, a polyrepo approach uses multiple repositories for each project @henderson_Monorepovspolyrepo_2024.

In this experiment, a monorepo strategy will be employed. This approach involves storing all micro frontends, a UI library, toolings, and a server application in a single repository, simplifying the setup stage, especially within the scope of this experiment.

Aligning with the monorepo strategy, the project structure is designed to ensure clarity and scalability. The structure is organized into several key directories, each serving a specific purpose. Below is an overview of the project structure:

#grid(
  columns: (1.03fr, 2fr),
  gutter: 10pt,
  [
    #figure(caption: "Project structure in the experiment.")[
      ```
      .
      ├── apps
      │   ├── home
      │   ├── lotto
      │   ├── shell
      |   └── ...
      |
      ├── packages
      |   ├── ui
      |   ├── mfe-config
      |   └── ...
      |
      ├── server
      |
      ├── e2e
      |
      ├── tools
      |   ├── tailwindcss
      |   └── ...
      |
      └── ...
      ```
    ]<figure_project_structure>
  ]
 ,
  [
    - apps: This directory contains the host, known as shell application (`shell`), which integrates and manages remotes, referred to as micro frontends, such as `home` and `lotto`. Each remote, along with the host, is developed and maintained within its own subdirectory.

    - packages: Here stores shared logic and resources, such as the `ui` library or `mfe-config`, an overview configuration file for all applications. These shared packages ensure consistent styling and functionality throughout the project.

    - server: This folder houses the server application, which acts as a simulated backend, processing requests from the micro frontends.

    - e2e: Here are end-to-end tests for the application, which are an important part of the continuous integration pipeline.

    - tools: This directory holds based configurations for development dependencies such as Tailwind CSS.
  ]
)

=== App Configurations

- For host application (`shell`)

In the vite configuration shown in @figure_vite_config_shell, `@originjs/vite-plugin-federation` plugin is used to establish the host application running on port `8000`. This host is configured to have two remote applications, `home_app` and `lotto_app`, which operate on ports `8001` and `8002`, respectively. The configuration also includes the `shared: ['vue']` option, ensuring that the Vue package is shared between the host and the remote applications.

#figure(
  caption: "Vite configuration for the host application."
)[
  ```ts
  // apps/host/vite.config.ts
  import federation from '@originjs/vite-plugin-federation'
  export default defineConfig({
    plugins: [
      federation({
        remotes: { 
          'home_app': 'http://localhost:8001/assets/remoteEntry.js',
          'lotto_app': 'http://localhost:8002/assets/remoteEntry.js'
        },
        shared: ['vue'],
      }),
    ],
    server: { port: 8000 }
  })
  ```
] <figure_vite_config_shell>

#pagebreak()
- For remote applications (`home` and `lotto`)

As outlined in the configuration for the host application (@figure_vite_config_shell) the `home_app` is configured to run on port `8001`, while the `lotto_app` is set to run on port `8002`. Both remote applications also use the `@originjs/vite-plugin-federation` plugin to expose their respective `App` components from their source directories (@figure_vite_config_home_and_lotto). These `App` components can later be imported and displayed, for example, using `import HomeApp from 'home_app/App'`.

#figure(
  caption: "Vite configuration for the home and lotto applications."
)[
  ```ts
  // apps/home/vite.config.ts
  import federation from '@originjs/vite-plugin-federation'
  export default defineConfig({
    plugins: [
      federation({
        name: 'home_app',
        exposes: { './App': './src/App.vue' },
        shared: ['vue'],
      }),
    ],
    server: { port: 8001 }
  })
  ```
  ```ts
// apps/lotto/vite.config.ts
import federation from '@originjs/vite-plugin-federation'
export default defineConfig({
  plugins: [
    federation({
      name: 'lotto_app',
      exposes: { './App': './src/App.vue' },
      shared: ['vue'],
    }),
  ],
  server: { port: 8002 }
})
```
] <figure_vite_config_home_and_lotto>

#pagebreak()

- For UI library

To prevent a single point of failure that could potentially bring down the entire application if the UI library fails, the UI will be bundled within each micro frontend during the compile time, rather than being deployed as a separate micro frontend. This approach ensures that all essential base elements are packaged together, thereby simplifying the management of multiple deployments and minimizing the risk of version inconsistencies. As illustrated in @figure_vite_config_ui, the UI library will be built using the ES module format. Additionally, the Vue package is excluded from the build, as it is already present in both the host and remote applications.

#figure(
  caption: "Vite configuration for UI library",
)[
  ```ts
  // apps/host/vite.config.ts
  export default defineConfig({
    build: {
      lib: {
        entry: 'src/index.ts',
        fileName: 'index',
        formats: ['es'],
      },
      rollupOptions: {
        external: ['vue'],
        output: { globals: { vue: 'Vue' } },
      }
    }
  })
  ```
] <figure_vite_config_ui>

#pagebreak()
=== Tailwind CSS

To ensure consistent styling across all applications, a base Tailwind CSS configuration has been established, as illustrated at the top of @figure_tailwind. This setup allows Tailwind CSS to scan all Typescript and Vue files to generate the required styles. The `preflight` option, responsible for generating reset CSS rules, is enabled exclusively in the shell application, which helps minimize the amount of CSS that users need to download. Furthermore, a specific set of colors has been defined to maintain a uniform color scheme across the applications. At the bottom of @figure_tailwind is the `tailwind.config.ts` file for the shell application, which extends this base configuration.

#figure(
  caption: [The default Tailwind CSS configuration, along with its extended version.]
)[
  ```ts
  // tools/tailwind/index.ts
  export default {
    content: ['src/**/*.{vue,ts}'],
    corePlugins: {
      preflight: false,
    },
    theme: { 
        colors: { 
          primary: '#d22321',
          secondary: '#c5c5c5'
        }  
    }
  }
  ```
  ```ts
  // apps/shell/tailwind.config.ts
  import config from '@dklb/tailwind'
  export default {
    content: config.content,
    corePlugins: {
      preflight: true,
    },
    presets: [config],
  }
  ```
] <figure_tailwind>

== Implementation Stage <section_implementation>

Following the selection of the required development tools, this stage focuses on implementing the host application, the two micro frontends (`home` and `lotto`), the UI library, and the server application. Additionally, a routing issue will be identified during this process, and a solution will be developed to address it.

A quick note: Vue Router #footnote[https://router.vuejs.org/], the official routing library for Vue.js, is used in this experiment to manage routing.

=== Host Application

The host application should be simple and lightweight, including elements that remain consistent across all pages, such as the navigation menu and footer. For the main content area, the `RouterView` component from Vue Router is utilized as a slot, responsible for loading the appropriate registered component based on the current URL state.

#figure(
  caption: "App component of the host application."
)[
  ```vue
  <!-- apps/shell/App.vue -->
  <template>
    <TheNav />
    <main
      <RouterView />
    </main>
    <TheFooter />
  </template>
  ```
]

After defining the entry component `App.vue`, all necessary routes will be registered as illustrated in @figure_shell_router. The first route is associated with `home` micro frontend for the path `/`, representing the homepage. The second route, mapped to `lotto` micro frontend, corresponds to the path `/lotto6aus49`, where users can participate in lotto games. If no path matches the specified routes, the user is redirected to an error page, which is handled by the `Error.vue` component.

Vue Router supports lazy loading of components using the promise syntax. For example, the syntax `component: () => import('home_app/App')` means that the `App` component of the `home` application is only loaded when the user navigates to the homepage. This optimization reduces the amount of JavaScript that needs to be downloaded initially, improving page load times.

#figure(
  caption: [Router configuration of the host application.]
)[
  ```ts
  // apps/shell/router.ts
  const router = createRouter({
    routes: [
      {
        path: '/',
        component: () => import('home_app/App'),
      },
      {
        path: '/lotto6aus49',
        component: () => import('lotto_app/App'),
      },
      {
        path: '/:pathMatch(.*)*',
        component: () => import('./pages/Error.vue'),
      },
    ],
  })
  ```
] <figure_shell_router>

=== Micro Frontends

The implementation of each micro frontend is straightforward and aligns with the development of a normal single-page application. For instance, the `App.vue` component in the `home` micro frontend might contain a simple heading displaying "Homepage". When a user navigates to the homepage, Vue Router loads this template into the `App` component of the `shell` application, producing the result shown below.

#figure(
  caption: [The `App` component of the `shell` application after the `home` is loaded.]
)[
  ```html
  <!-- apps/home/App.vue -->
  <template>
    <h1>Homepage</h1>
  </template>
  ```
  ```html
  <!-- apps/shell/App.vue -->
  <template>
    <TheNav />
    <main>
      <h1>Homepage</h1>
    </main>
    <TheFooter />
  </template>
  ```
]

=== UI Library

The UI library must be designed to be minimal, highly extensible, and independent of any specific location within the application, ensuring its effectiveness and usability across various parts of the system.

As shown in @figure_button_ui_with_customized, a basic `UiButton` component is implemented as a simple HTML button element with predefined Tailwind CSS classes and no context-specific logic. If the home micro frontend requires a customized button, it can create a wrapper around this component to extend its styles, as demonstrated by the `HomeButton` component.

#figure(
  caption: [The `UiButton` component and its wrapper `HomeButton`.]
)[
  ```vue
  <!-- packages/ui/UiButton/UiButton.vue -->
  <template>
    <button class="inline-flex text-sm uppercase">
      <slot />
    </button>
  </template>
  ```
  ```vue
  <!-- apps/home/components/HomeButton.vue -->
  <template>
    <UiButton class="bg-primary text-white"> 
      <slot />
    </UiButton>

    <!-- will be rendered as below -->
    <button class="inline-flex text-sm uppercase bg-primary text-white">
      <slot />
    </button>
  </template>
  ```
] <figure_button_ui_with_customized>

=== Server Application

The server application is configured to listen on port `3000` and only accepts requests originating from port `8000`, where the host application is running. It verifies the request's origin, setting `authorized` to true or false based on whether the origin is `localhost:8000`, and configures CORS to permit only this specific origin. This setup creates a security layer that helps prevent unauthorized requests from third parties, including REST clients like Postman or web browsers, ensuring that only the host application can securely interact with the server application.

#figure(
  caption: [The configuration for the server application.]
)[
  ```ts
   const app = new Elysia()
    .derive(({ request }) => {
      const origin = request.headers.get('origin')
      return { authorized: origin === 'http://localhost:8000' }
    })
    .use(
      cors({
        origin: /http:\/\/localhost:8000/
      }),
    )
    .listen(3000)
  ```
] <figure_server_config>

=== Routing Problem

The path `/lotto6aus49` alone is insufficient to fully represent the entire subdomain for the Lotto game, as there is still a need for a page to view the results of previous draws. A proposed solution is to use `/lotto6aus49` as a prefix and then remove the existing route, replacing it with two new routes: one for displaying the play field at `/lotto6aus49/normalschein` and another for querying previous results at `/lotto6aus49/quoten`.

#figure(
  caption: "Router of the host application with recently added routes."
)[
  ```ts
  // apps/shell/router.ts
  const router = createRouter({
    routes: [
      // ...
      {
        path: '/lotto6aus49/normalschein',
        component: () => import('lotto_app/Normalschein'),
      },
      {
        path: '/lotto6aus49/quoten',
        component: () => import('lotto_app/Quoten'),
      },
      // ...
    ],
  })
  ```
]

Additionally, the `lotto` micro frontend must expose its corresponding components for these new routes, ensuring that the correct components are available to be loaded and displayed by the host application.

#figure(
  caption: [Vite configuration for lotto micro frontend with more exposed components.],
)[
```ts
// apps/lotto/vite.config.ts
export default defineConfig({
  plugins: [
    federation({
      name: 'lotto_app',
      exposes: { 
        './Normalschein': './src/Normalschein.vue',
        './Quoten': './src/Quoten.vue',
      },
      shared: ['vue']
    }),
  ]
})
```
]

These routes share the prefix `/lotto6aus49`, which suggests that a separate Vue Router instance should ideally be created within the `lotto` micro frontend to manage its nested routes. This approach would allow the host application's router to register only the top-level routes for its remotes, while deeper-level routing would be handled within each micro frontend. However, this approach is not feasible under the current Module Federation setup. In this architecture, only a single instance of Vue is created within the host application, which utilizes the router defined in @figure_shell_router. Consequently, no additional Vue or Vue Router instance exists within the `lotto` micro frontend to manage nested routing independently.

However, if a new route is now required to display instructions for the Lotto game, or if an existing route, such as the one for displaying results, needs to be removed, similar steps must be repeated to achieve the desired outcome. This repetition not only increases the potential for errors but also indicates a poor developer experience. Therefore, a more automated solution is desirable, which would involve creating a mechanism where routes can be dynamically registered and managed without the need for extensive manual input.

#pagebreak()
=== Routing Solution

1. Overview configuration

The initial step in this routing solution is to create an overview configuration for all applications. This overview specifies the directory locations, operating ports, names, and prefixes for each application. This configuration is important not only for defining how each micro frontend is served but also for enabling the host application to access information about its remotes. Henceforth, the term "overview configuration" will refer to this specific configuration.

#figure(
  caption: "Overview configuration for all applications."
)[
  ```js
  // packages/mfe-config/index.js
  export default {
    shell: {
      dir: 'shell',
      port: '8000',
    },
    home: {
      dir: 'home',
      port: '8001',
      name: 'home_app',
      prefix: '/',
    },
    lotto: {
      dir: 'lotto',
      port: '8002',
      name: 'lotto_app',
      prefix: '/lotto6aus49',
    },
  }
  ```
] <figure_mfe_config>

2. Automated Components Exposure

Firstly, a list of routes needs to be generated. Drawing inspiration from the file-based routing systems used by popular meta-frameworks like Nuxt.js, a similar approach will be implemented to create this list. Secondly, this list of routes will be converted into a format that the vite plugin can understand. Finally, a wrapper function will encapsulate these processes and return a value that will be passed into the vite configuration for the host application. Additionally, to enhance flexibility, this wrapper function can also accept extended exposes, for cases where components cannot be located at the specified locations, and custom remotes, which enable a horizontal-split method. The minimal code for this implementation is provided below.

#figure(
  caption: [A wrapper function is built on top of the vite plugin.],
  [
    ```js
   function wrapper(name, _exposes, _remotes){
     const files = getFiles(name)
     const exposes = getExposes(files, _exposes)
     saveExpsoses()
     const remotes = getRemotes(_remotes)
     return federation({
       name,
       exposes,
       remotes
     })
   }
    ```
  ]
) <figure_wrapper_function>

In the context of the `lotto` micro frontend, its folder structure is illustrated in @figure_folder_structure_lotto, left. After the execution of the wrapper function, a `routes.json` file is temporarily saved on disk and also included in the `exposes` object, which the host application will later access. The content of this file is illustrated in @figure_folder_structure_lotto, right.

#figure(
  caption: [The folder structure of the `lotto` micro frontend (left) and the generated `routes.json `file (right).]
)[
  #grid(
    columns: (1fr,1fr),
    gutter: 10pt,
    [
      ```
      .
      └── apps
          ├── lotto
          │   │ 
          │   ├── pages
          │   │   ├── normalschein.vue
          │   │   └── quoten.vue
          │   └── ...
          │ 
          └── ...
      ```
    ],
    [
      ```json
      [
        { 
          "path": "/normalschein", 
          "component": "Normalschein" 
        },
        { 
          "path": "/quoten", 
          "component": "Quoten" 
        }
      ]
      ```
    ]
  )


] <figure_folder_structure_lotto>

#pagebreak()
3. Automated Routes Registration

The final step in this routing solution is the automated registration of routes. With the overview configuration established in the first step and the details about the exposed components of each micro frontend obtained in the second step, the host application's router can now iterate through the overview configuration, reading the corresponding `routes.json` file and then process compiles a flat array of all possible routes within the application.

#figure(caption: [Router configuration with automated routes registration.])[
  ```ts
  const router = createRouter()
  for (const config of mfeConfig){
    const routes = getRoutes(config)
    router.addRoutes(routes)
  }
  app.use(router)
  ```
]

From now on, any changes in the directory monitored by the wrapper function will automatically trigger the creation of a router with the correct routes, ensuring the proper routing of the application.

== Build Stage

As illustrated in the dependencies graph below, the UI library must be built before both the host application and the micro frontends. This sequence is necessary because the UI library is not defined as a separate micro frontend but rather as a dependency that is bundled during the build process. Once the UI library is built, the host and remote applications can be built either sequentially or in parallel, as their dependencies are resolved only at runtime. In contrast, the server application, which has no dependencies, can be built in the usual manner without any special considerations.

#figure(
  image("/assets/build.png", width: 80%),
  caption: "Dependencies graph: Solid arrows indicate build-time dependencies; Dashed arrows indicate runtime dependencies."
)


== Testing Stage

The testing stage is focused on verifying the functionality and reliability of the application, ensuring that all components operate as expected before deploying to production. In this experiment, two types of testing will be covered: unit testing and end-to-end testing.

=== Unit Testing

Unit testing focuses on the smallest testable parts of the application, such as individual functions or components. Due to their limited scope and complexity, unit tests typically execute quickly. It is advisable to write unit tests for each component and utility function during the development process, particularly for the UI library. Below are two basic unit tests for the `UiButton` component from the UI library.

#figure(caption: [Two unit tests for the `UiButton` component.])[
  ```ts
  // packages/ui/UiButton/UiButton.test.ts
  const slots = { default: () => 'Click me' }

  it('should be rendered as a button', () => {
    const component = mount(UiButton, { slots })
    const button = component.find('button')
    expect(button.exists()).toBe(true)
    expect(button.text()).toBe('Click me')
  })
  
  it('should be rendered as a link', () => {
    const component = mount(UiButton, { slots, props: { to: '/about' } })
    const anchor = component.find('a')
    expect(anchor.exists()).toBe(true)
    expect(anchor.text()).toBe('Click me')
    expect(anchor.attributes('href').toBe('/about')
  })
  ```
]
=== End-to-End Testing

End-to-end (E2E) testing is a comprehensive method for evaluating the entire workflow of an application. Unlike unit tests, which focus on isolating components within a simulated environment, E2E testing replicates user interactions in a production-like setting to ensure that the system meets its requirements and functions as expected. Below is a basic E2E test intended to validate the navigation workflow.

#figure(caption: [Simple E2E test to test the navigation workflow.])[
  ```ts
  // e2e/tests/app.test.ts
  test('Navigation', async ({ page }) => {
    await page.goto('http://localhost:8000/')
    await expect(page).toHaveTitle('LOTTO Berlin')

    const playBtn = page.getByRole('link', { name: /Jetzt Spielen/ }))
    await expect(playBtn).toBeVisible()
    await playBtn.click()
  
    const url = page.url()
    expect(url).toBe('http://localhost:8000/lotto6aus49/normalschein')

    const heading = page.getByRole('heading', { name: /Normalschein/ }))
    await expect(heading).toBeVisible()
  })
  ```
]

== Deployment Stage

After completing the building and testing stages, this phase shifts its focus to determining the most effective solution for containerizing the application using Docker.

=== Server Container

The Dockerfile of the server application defines a two-stage build process. In the first stage, the application is built by installing dependencies and compiling the code. The second stage uses the same base image and copies the compiled output from the first stage. This approach helps keep the final Docker image small and efficient by including only the essential files needed to run the application. Finally, the Dockerfile exposes the necessary port and specifies the command to start the server application when the container is launched.

#figure(caption: "Dockerfile for the server application.")[
  ```Dockerfile
  # dockers/Dockerfile.server
  FROM oven/bun:slim AS build
  WORKDIR /dklb
  COPY ./server ./
  RUN bun install && bun run build
  
  FROM oven/bun:slim
  COPY --from=build /dklb/dist/index.js ./index.js
  EXPOSE 3000
  ENTRYPOINT ["bun", "run", "./index.js"]
  ```
]

=== Containers for Micro Frontends

To avoid the problems related to manual management, particularly regarding routing issues during the implementation phase, an automated approach for generating Dockerfiles based on the overview configuration is preferred. This approach involves two steps: first, generating an Nginx configuration file for both the host and remote applications, and second, creating a corresponding Dockerfile for each of these applications.

1. Nginx configurations

Firstly, @cors headers must be appended to each nginx configuration of remote applications. This step is essential to guarantee that only requests originating from the host application are permitted and also prevent any CORS-related issues. Secondly, the host's nginx configuration is configured to always attempt to load the `/index.html` file, regardless of the URI requested. Without this configuration, the nginx server may return a "Not found" error for requests that do not explicitly point to existing resources.

#figure(caption: [Generation of `nginx.conf` files based on the overview configuration.])[
```ts
// scripts/docker.ts
const cors = `
add_header 'Access-Control-Allow-Origin' 'http://localhost:8000';
add_header 'Access-Control-Allow-Methods' 'GET';
add_header 'Access-Control-Allow-Headers' 'Content-Type';`

for (const { port, dir } of Object.values(mfeConfig)) {
  const isShell = dir === 'shell'
  const path = `.nginx/${dir}.conf`
  const str = `
  server {
    listen ${port};
    server_name localhost_${dir};
    ${isShell ? '' : cors}
    location / {
      root      /usr/share/nginx/html/${dir};
      index     index.html;
      ${isShell ? 'try_files $uri $uri/ /index.html;' : ''}
  }`
  await write(path, str)
}
```
]

2. Dockerfiles

The process of generating Dockerfiles for each micro frontend can be seamlessly integrated into the same loop that creates the Nginx configuration files. The Dockerfile follows a two-stage approach. In the first stage, the necessary files and dependencies are gathered, followed by the build process for the UI library and the specific micro frontend. The second stage sets up the environment for serving the micro frontend. By removing the default configuration, this stage ensures that only custom configurations and assets are used, and it prepares the built assets to be served by the web server on the defined port. Lastly, the command to start the server application by launching the container is specified.

#figure(caption: [Generation of the `Dockerfile` files based on the overview configuration.])[
  ```ts
  // scripts/docker.ts
  const content = `
  FROM oven/bun:slim AS build
  WORKDIR /dklb
  COPY . .
  RUN bun install
  RUN bun run build:ui
  RUN bun run --cwd apps/${dir} build
  
  FROM nginx:alpine
  WORKDIR /usr/share/nginx/html
  RUN rm -rf * && rm -f /etc/nginx/conf.d/default.conf
  COPY .nginx/${dir}.conf /etc/nginx/conf.d
  COPY --from=build /dklb/apps/${dir}/dist ${dir}
  EXPOSE ${port}
  ENTRYPOINT ["nginx", "-g", "daemon off;"]`

  await write(`dockers/Dockerfile.${dir}`, content)
  ```
]

=== Docker Compose

The final step in this deployment section involves using docker-compose, a convenient tool for simplifying the process by allowing to define and run multiple docker containers.

The server application's service is first defined, specifying the location of its Dockerfile and the port it will run on. Following this, the overview configuration is looped through again to generate service definitions for each micro frontend. These definitions include the service name, relevant build settings, and necessary port mappings. The script also ensures that each micro frontend service waits for the server to start, maintaining the correct initialization sequence. Once all configurations are defined, they are written into a `docker-compose.yml` file.

This Docker-based strategy enables the @dklb application to be easily deployed on any machine with Docker installed, streamlining the deployment process and ensuring consistency across different environments.

#figure(caption:[Generation of `docker-compose.yml` file based on the overview configuration.])[
  ```ts
  const contents = [
  `services:
      server:
        build:
          context: .
          dockerfile: dockers/Dockerfile.server
        ports:
          - '3000:3000'`,
  ]

  for (const { port, dir } of Object.values(mfeConfig)) {
    const content = `
    ${dir}:
      build:
        context: .
        dockerfile: dockers/Dockerfile.${dir}
      ports:
        - '${port}:${port}'
      depends_on:
        - server`
    contents.push(content)
  }

  await write('docker-compose.yml', contents.join('\n'))
  ```
]

=== Other Containerization Approach

In the containerization approach implemented above, each micro frontend is deployed in its container. This design, while flexible, results in increased memory usage, as the memory requirements scale with the number of micro frontend containers. An alternative is to run the host application and all micro frontends only within a single container. As illustrated in @figure_docker_desktop, the multi-container approach requires around 27MB of memory, whereas the single-container approach needs only about 9MB for the entire frontend. This reduction in memory usage can be advantageous in resource-constrained environments.

However, the single-container approach has trade-offs. Redeploying a micro frontend in this setup can be more cumbersome, as developers must apply the necessary changes, rebuild the micro frontend, and push the built assets to the correct directory in the container, responsible for that micro frontend. In some scenarios, this might even require taking down the entire container, leading to downtime for the whole application. On the other hand, with the multi-container approach, individual containers can be stopped and restarted independently, allowing updates to specific micro frontends without disrupting the entire system. This independence reduces the operational burden on developers and can minimize application downtime.

Several deployment strategies are available that can optimize the deployment process and effectively address the issues previously mentioned. One such strategy is blue-green deployment, which involves the use of two identical production environments, referred to as blue and green. The blue environment handles live traffic, while the green environment remains idle or is used for staging new releases. When a new version is ready, it is deployed to the green environment. After comprehensive testing, traffic is switched to the green environment, allowing for seamless updates. Should any issues arise, traffic can be reverted to the blue environment. This approach ensures minimal downtime during deployments, enhances reliability, and offers quick rollback capabilities @fowler_BlueGreenDeployment_2013.

In this experiment, both single and multi-container approaches are suitable. However, if the @dklb project later decides to adopt a micro frontend architecture and must select one, it will be essential to carefully weigh the importance of memory efficiency against the flexibility and ease of maintenance.

#show image: it => block(radius: 5pt, clip: true)[#it]  
#figure(
  caption: "Memory usage comparison: multi-container vs. single-container approach.",
  image("/assets/docker_idle.png")
)<figure_docker_desktop>
#show image: it => it  


== CI/CD Stage

In this final stage of the experiment, the process for automating the integration of code changes from all applications and the UI library into the main branch is executed. This automation involves running linting, building, and testing tasks within each application. These steps enable the early detection of issues, ensure compatibility between new code and the existing codebase, and maintain a high standard of code quality. To provide a concrete example, the following section presents a code snippet that defines a pipeline for end-to-end testing, which is triggered when a pull request is made to the main branch. For clarity, the specific commands for each step have been omitted.

#figure(caption: "Pipeline configuration for end-to-end testing.")[
  ```yml
  # .github/workflows/e2e.yml
  name: e2e
  on:
    pull_request:
      branches:
        - main
  jobs:
    e2e:
      runs-on: ubuntu-latest
      steps:
        - name: Checkout Repo
        - name: Setup Bun
        - name: Install Dependencies
        - name: Setup Docker
        - name: Build Images
        - name: Run Containers
        - name: Install Playwright
        - name: Wait for Containers
        - name: Run E2E Tests
        - uses: Upload Report
        - name: Stop Containers
  ```
]

After completing the code integration, the focus shifts to automated deployment. Digital Ocean has been selected as the provider for the virtual private server (VPS). Significant effort has been invested in generating the necessary Docker configuration files during the deployment stage. The following code snippet demonstrates the action file used to manage the deployment process. This workflow is triggered whenever new code is pushed to the main branch and contains three primary steps: configuring SSH keys, installing the command-line interface for Digital Ocean, and establishing access to the VPS. Once access is secured, a sequence of commands is executed, including pulling the latest code via Git, bringing down existing Docker containers, rebuilding them, and bringing them back up.

#figure(caption: "Pipeline configuration for deployment.")[
  ```yml
  # .github/workflows/e2e.yml
  # ...
  steps:
    - name: Set up SSH
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa

    - name: Install doctl
      uses: digitalocean/action-doctl@v2
      with:
        token: ${{ secrets.DIGITAL_OCEAN_TOKEN }}

    - name: Redeploy on Droplet
      run: |
        doctl compute ssh ${{ env.DROPLET_ID }} --ssh-command "
          cd /root/DKLB
          git pull origin main
          bun run prepare:docker
          docker compose down
          docker compose up --build -d
        "
  ```
]


== Developer Workflow Optimization 

To enhance the developer workflow, a scaffold script is implemented to streamline the creation of new micro frontend applications. Initially, a `.template` directory is established to store the templates for the micro frontend application and the pipeline configuration file. Following this, a lightweight command line interface (CLI) is implemented to prompt the developer for the location and prefix of the micro frontend. The corresponding Dockerfile is then generated, and necessary updates are made to the `docker-compose.yml` file. Finally, the script asks whether to install dependencies or perform the build process.

#show image: it => block(radius: 5pt, clip: true)[#it]  
#grid(
  columns: (1fr, 1.5fr),
  column-gutter: 10pt,
  figure(
    caption: [`.template` directory's structure.],
    [
       ```
      .templates
      ├── app
      │   ├── src
      │   ├── vite.config.ts
      │   └── ...
      └── workflows
          ├── ci.yml
          └── ...
      ```
    ]
  ),
  figure(
    caption: [The scaffold CLI for the creation of new micro frontend applications.],
    image("/assets/create_app.png")
  ),
)
#show image: it => it

#pagebreak(weak: true)
