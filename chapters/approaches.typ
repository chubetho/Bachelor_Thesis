#import "@preview/glossarium:0.4.1": glspl

= Micro Frontend Implementation Approaches

Building on the Decision Framework outlined in the previous chapter, this section presents several commonly adopted approaches for implementing micro frontends. The effectiveness and challenges of these approaches often depend on the composition strategy they are paired with. As a result, general benefits and drawbacks will not be discussed here, except in cases where a specific approach has distinct characteristics.

The following approaches utilizing server-side and edge-side composition will be demonstrated within a horizontal-split strategy, while those employing client-side composition will be explored through a vertical-split strategy.

== Server-Side Includes

@ssi is a server-side scripting language often used in a server-side composition approach, where web pages are constructed on the server by fetching content from various micro frontends before delivering the final page to the user. @ssi accomplishes this by providing a set of specific directives within an @html file, which the server processes to execute commands such as setting variables, printing the current date and time, or including common elements from other files, like headers or footers, within the page @_IntroductionServerSide_. This capability makes @ssi particularly useful for maintaining consistency across multiple pages of a website.

However, @ssi's utility is generally limited to simpler tasks, as it lacks the flexibility and power required for more complex website architectures. While @ssi is effective at including static components across multiple pages, it is not designed to support dynamic interactions between components within a single page. Since page composition occurs on the server side, any communication between different micro frontends within the view must be routed through the server, typically using REST APIs or similar server-side communication methods. Consequently, @ssi is better suited for basic page assembly tasks rather than for scenarios that demand complex, interactive user interfaces or real-time communication between components.

#figure(caption: [An example of using Server Side Includes.])[
  ```html
  <!-- http://header.mfe/index.html -->
  <html>
    <header>Header</header>
  </html>
  ```
  ```html
  <html>
    <body>
       <!--#include virtual="http://header.mfe/index.html" -->
       <!--#include virtual="http://catalogue.mfe/index.html" -->
       <!--#include virtual="http://footer.mfe/index.html -->
    </body>
  </html>
  ```
]

Additionally, several frameworks are specifically designed to implement micro frontend architectures in combination with server-side composition, such as OpenComponents #footnote[https://opencomponents.github.io/], OneApp from American Express #footnote[https://github.com/americanexpress/one-app], Mosaic from Zalando #footnote[https://www.mosaic9.org/], and Podium #footnote[https://podium-lib.io/]. These frameworks offer more robust solutions for developing modular, scalable frontend applications.


== Edge-Side Includes

The primary purpose of @esi, a markup language, is to enable edge-side composition, which allows web pages to be constructed from fragments directly at the edge of the network. The key difference between @esi and @ssi lies in where the page assembly occurs: @esi operates at the network edge, typically within a @cdn, whereas @ssi performs this function on the server-side @_ESIDocument_2004.

However, @esi implementations can vary significantly across different #glspl("cdn")  and may not be supported by all. In cases where @esi is unsupported, tools like nginx or Varnish can be employed to mimic @esi's functionality by providing similar edge-side processing capabilities. These tools can intercept requests and dynamically assemble content at the edge. Furthermore, @esi shares some of the same disadvantages as @ssi, such as being more suitable for simple static websites and offering limited communication capabilities between components.

#figure(caption: [An example of using Edge Side Includes.])[
  ```html
  <!-- http://cdn.mfe/header.html -->
  <html>
    <header>Header</header>
  </html>
  ```
  ```html
  <html>
    <body>
       <esi:include src="http://cdn.mfe/header.html" />
       <esi:include src="http://cdn.mfe/catalogue.html" />
       <esi:include src="http://cdn.mfe/footer.html" />
    </body>
  </html>
  ```
]

== iframe

An iframe is an inline frame embedded within a webpage that allows the loading of a separate HTML document from different sources. It offers one of the highest levels of isolation within a browser, as it maintains its own context and resources independently from the parent document @_InlineFrameElement_2024. Because of this strong isolation, communication between iframes often relies on the `postMessage` method @_WindowPostMessageMethod_2024. Additionally, iframes are advantageous due to their ease of implementation, making them a common and intuitive choice when considering micro frontend architectures.

Despite the strong isolation benefits provided by iframes, their performance is often criticized by the community for being suboptimal and CPU-intensive, particularly on websites that use multiple iframes. This performance issue, combined with the difficulty of making iframes easily indexable by search engine crawlers, limits their suitability primarily to desktop or intranet applications, as demonstrated by Spotify's use of iframes in their desktop apps @engineering_BuildingFutureOur_2021. Additionally, accessibility concerns arise with iframes. While they can visually integrate seamlessly into a web application, they essentially represent separate small pages within a single view, which can pose significant challenges for accessibility tools like screen readers. These tools must navigate multiple documents, hierarchical information, and varying navigation states within a single page, complicating the user experience for individuals with disabilities.

This approach is a type of client-side composition. As explained in @section_decision_framework, this composition strategy starts with the browser downloading a shell application, which manages the loading and unloading of various micro frontends. As illustrated in the figure below, the shell application determines the appropriate @html file path based on the current URL and assigns it as the source of the iframe element.

#figure(caption: [An example of using iframe.])[
  ```html
  <!-- http://home.mfe/index.html -->
  <html>
    <body>
      <h1>Home</h1>
      <!-- other elements -->
    </body>
  </html>
  ```
  ```html
  <html>
    <body>
      <iframe src="" />

      <script>
        const routes = {
          '/':         'http://home.mfe/index.html',
          '/product':  'http://product.mfe/index.html',
        }
        const src = routes[window.location.pathname]
        const iframe = document.querySelector('iframe')
        iframe.src = src
      </script>
    </body>
  </html>
  ```
]<figure_approach_iframe>

== Web Components

Web components are a collection of web platform APIs that enable developers to create reusable and encapsulated custom elements. These components are based on three key specifications: Custom Elements, Shadow DOM, and HTML Templates @_WebComponentsWeb_2024.

- Custom Elements: This set of JavaScript APIs allows developers to define their own HTML elements with custom behaviors. Once defined, these elements can be used just like standard HTML tags.

- Shadow DOM: Another set of JavaScript APIs provides encapsulation by creating a hidden context, a shadow DOM, that includes the internal structure, styles, and behavior of the component. This encapsulation ensures that the component is isolated from the rest of the main DOM, preventing style and script conflicts.

- HTML Templates: This feature allows developers to define reusable HTML fragments that are not rendered during the initial page load. These templates can be reused as needed throughout the application.

While web components provide substantial benefits, they also present certain challenges. The concept of web components has been around for some time, however, full support is only available in modern browsers. To maintain compatibility with older browsers, developers often need to rely on polyfills #footnote[https://remysharp.com/2010/10/08/what-is-a-polyfill]. Additionally, the use of custom elements and the shadow DOM within web components differs from traditional frontend development practices, which may introduce a learning curve for developers who are not yet familiar with these concepts.

Web components are primarily intended for client-side composition, where they are rendered and executed within the browser. However, they can also be integrated with server-side composition by having the server load other parts of the @html, while the web components are executed after the page has been loaded, allowing for a hybrid composition strategy.

At the time of writing this thesis, a framework called Lit #footnote[https://lit.dev/] had already experimentally achieved the ability to render web components on the server-side.

#figure(caption: [An example of using Web Components.])[
  ```js
  // http://home.mfe/index.js
  class HomeApp extends HTMLElement  {
    constructor(){
      const shadowRoot = this.attachShadow({ mode: 'open' })
      const heading = document.createElement('h1')
      heading.textContent = 'Home'
      shadowRoot.appendChild(heading)
    }
  }
  customElements.define('home-app', HomeApp)
  ```
  ```html
  <html>
    <head>
      <script src="http://home.mfe/index.js"></script>
      <script src="http://product.mfe/index.js"></script>
    </head>
    <body>
      <div id="root">
        <home-app /> <!-- <h1>Home</h1> -->
      </div>

      <script>
        const routes = {
          '/':         'home-app',
          '/product':  'product-app',
        }
        const root = document.getElementById('root')
        const elementName = routes[window.location.pathname]
        const element = document.createElement(elementName)
        root.appendChild(element)
      </script>
    </body>
  </html>
  ```
]

#pagebreak()

== Module Federation

Module Federation, introduced in Webpack 5 #footnote[https://webpack.js.org/], is a feature of this popular JavaScript bundler that enables different parts of an application to be treated as separate modules. These modules can be shared and used by other parts of the application at runtime @_ModuleFederation_. There are two types of modules:

- Exposed Module: Also referred to as a remote application, this is a module that is made available for other applications to consume. It can change its behavior at runtime and is typically defined to provide resources such as a component library or utility functions to other parts of the application.

- Consuming Module: Known as the host application, this module can utilize exposed modules without needing to bundle them directly into its codebase. As a result, if the exposed module is updated, the consuming application automatically integrates the latest version.

Module Federation is an approach that can be seamlessly integrated with both vertical and horizontal splitting strategies, as well as with client-side or server-side composition. In a survey on micro frontends conducted in late 2023 @steyer_ConsequencesMicroFrontends_2023, Module Federation appeared as the most adopted approach, highlighting its effectiveness as a solution in modern web development.

Moreover, enabling code sharing across different parts of an application, significantly reduces duplication and decreases the overall size of the application bundle compared to iframe or Web Components. For instance, if multiple micro frontends rely on the same library, they can all access a single shared instance rather than bundling it separately in each module.

However, Module Federation introduces certain complexities, particularly in managing the versions of shared modules across different applications. This process can be complex and requires careful configuration, especially in environments with multiple modules or complex dependency structures. The challenge is further expanded when dealing with commonly used modules that are widely consumed by other parts of the application. These modules must be cautiously managed and monitored to avoid becoming a single point of failure, as any changes to them can have widespread effects across the entire application ecosystem.

#figure(caption: [An example of using Module Federation.])[
  ```vue
  <!-- home/App.vue -->
  <template>
    <h1>Home</h1>
  </template>
  ```
  ```ts
  // home/webpack.config.js
  export default defineConfig({
    plugin: [
       new ModuleFederationPlugin({
          name: 'remote',
          exposes: { './App': './src/App.vue' },
          shared: ['vue'],
        }),
    ]
  })
  ```
  ```vue
  <!--  host/src/App.vue -->
  <script setup>
  import App from 'remote/App'
  </script>

  <template>
    <App /> <!-- <h1>Home</h1> -->
  </template>
  ```
]

#pagebreak(weak: true)