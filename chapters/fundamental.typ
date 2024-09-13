#import "@preview/glossarium:0.4.1": glspl

= Decision Framework <section_decision_framework>

This chapter will use the micro frontends decision framework introduced by Luca Mezzalira in his book "Building Micro Frontends". This comprehensive framework focuses on four key areas: definition, composition, routing, and communication @mezzalira_BuildingMicroFrontends2nd_. These areas are important and must be thoroughly considered sequentially and decided upon before starting to build a micro frontends system.

To provide a more rounded perspective and deepen the understanding of this framework, this chapter also uses insights from two other important works in the field. "The Art of Micro Frontends" by Florian Rappl @rappl_ArtMicroFrontends_2021 offers valuable additional viewpoints on best practices and advanced techniques. Similarly, Michael Geers's "Micro Frontends in Action" @geers_MicroFrontendsAction_2020 provides practical examples and case studies that illustrate the application of the micro frontends framework in real-world scenarios.

== Split Strategies <section_split>

There are two primary strategies to split a frontend application: horizontally or vertically. In both approaches, a micro frontend is defined to represent a complete subdomain, which can be categorized as core, supporting, or generic, as introduced in @section_ddd. A horizontal split implies a one-to-many relationship between views and micro frontends, where a single view is made up of multiple micro frontends, each responsible for a specific feature within that view. In contrast, a vertical split establishes a many-to-one relationship, where one micro frontend is responsible for managing the functionality of several views.

=== Horizontal-Split

In this approach, many micro frontends coexist within the same view, each responsible for a specific section of the page. For instance, in a product detail view (as illustrated in @figure_horizontal_split), three micro frontends managed by the product team, the recommendation team, and the checkout team collaborate to present a unified user interface within a single page.

#figure(
  image("/assets/horizontal_split_web.png"),
  caption: [A product detail view composed of three micro frontends.],
) <figure_horizontal_split>

Horizontal-split architecture is often chosen when there is a requirement for reusable micro frontends across different pages within the application. By supporting granular modularization, this method not only enhances reusability and flexibility but also promotes more efficient resource usage. Additionally, this approach proves particularly beneficial in scenarios where multiple teams are working simultaneously on the application, as it allows for the easy division of subdomains into smaller, manageable units.

Since each micro frontend functions as an isolated component of the user interface, any issues that arise within one section do not affect the entire application. This separation mitigates single points of failure, enhances overall stability, and facilitates more seamless updates and maintenance.

Despite its benefits, implementing a horizontal-split architecture presents considerable challenges. It demands strong governance, regular reviews, and effective communication among teams to ensure that each micro frontend maintains its proper boundaries. Additionally, the number of micro frontends within the same view needs to be limited. Over-engineering can lead to an excessive number of small micro frontends, blurring the line between a micro frontend (a business subdomain) and a component (a technical solution for reusability). This can lead to increased overhead, ultimately outweighing the potential advantages.

=== Vertical-Split

The vertical-split approach divides an application into multiple slices, with each team managing a specific subset within these slices. For instance, as illustrated in @figure_vertical_split, the recommendation team is responsible for the products overview page, which includes displaying new and recommended products to customers. While the product team handles the product detail view, including all specific information about a product.

#figure(
  image("/assets/vertical_split_web.png"),
  caption: [User workflow between two micro frontends.],
) <figure_vertical_split>

A key component of this architecture is the application shell, which is responsible for loading and unloading micro frontends. It is the first to be downloaded when the application is accessed and remains a persistent part of the application. The shell typically includes essential elements that appear on every page of the application, such as the navigation bar, footer, or general logic such as a user authentication system.

The vertical-split architecture is particularly beneficial for projects that require a consistent user interface across different sections. By loading the shell first, users experience a more responsive application, as the core interface elements become immediately available while other parts continue to load in the background. Additionally, each team is responsible for managing the complete user experience for their assigned subdomain, leading to a cohesive and unified interface throughout the application.

Moreover, for teams experienced in developing single-page applications, transitioning to a vertical-split micro frontend architecture is relatively straightforward. The tools, best practices, and design patterns from @spa development are directly applicable, allowing teams to leverage their existing expertise. This continuity reduces the need for extensive retraining and accelerates the implementation process.

Vertical-splits also bring notable challenges that require careful attention. A primary concern is the potential for redundant efforts and code duplication. Without careful management and coordination, individual micro frontends within a vertical-split architecture might independently develop their versions of common functions, such as data fetching or error handling. This redundancy not only increases the maintenance workload but also results in a larger, more complicated codebase. Managing these redundant components can become a complex and time-consuming task, reducing the efficiency that vertical-split architecture is intended to achieve.

Moreover, since a micro frontend represents multiple slices within the application, its failure could potentially impact a large number of users. For instance, in the online shopping application mentioned earlier, if the product detail page encounters an issue or becomes unavailable, customers will be unable to view products and make purchases. This could result in significant sales losses and a negative user experience.


== Composition and Routing

There are three primary composition types: server-side composition, edge-side composition, and client-side composition. The strategy used to divide the application impacts how different parts of the frontend are assembled into a view. Vertical-split approach supports only client-side composition, whereas horizontal-split approach can accommodate all three types. These composition methods correspond to three routing approaches, determined by where the routing logic is executed: server-side routing, edge-side routing, and client-side routing. Before exploring the details of each composition and routing mechanism, the difference between build-time integration and runtime integration will first be discussed.

=== Build-time vs. Runtime Integration

Build-time integration refers to the process where micro frontends are integrated during the build phase. In this approach, individual micro frontends are combined into a single deployable bundle before the application is served to the user. While this method allows for independence during the development stage, it results in coupling at the release stage. Consequently, even a minor change in a single micro frontend may necessitate recompiling the entire application, creating a modular monolith architecture that contradicts the fundamental principles of micro frontend architecture.

In contrast, runtime integration involves assembling the micro frontends dynamically when the application is loaded or accessed by the user. This approach helps avoid issues such as lock-step deployment, thereby maintaining the independence of each micro frontend. Given these considerations, runtime integration is generally preferred over build-time integration to prevent unnecessary coupling.

=== Server-Side

The server-side approach is a web development technique where the server manages routing logic and assembles different parts of an application before delivering a completed page to the client. This method is particularly effective when combined with a horizontal-split architecture as this combination offers greater flexibility in how different sections are composed.

This approach brings several advantages. By delivering a fully-rendered @html document, the browser can display the page quickly, reducing the computational load. This is especially beneficial for users with lower-powered devices, ensuring a faster and smoother content appearance and significantly enhancing the overall user experience. Additionally, the server-side approach is advantageous for @seo purposes. Search engines can easily crawl and index complete pages, leading to better rankings for websites using server-side composition.

However, during high-traffic periods, the server must handle multiple requests and assemble pages on the fly, which can strain server resources. This can result in slower navigation between pages or, in extreme cases, cause the server to freeze or crash. While a @cdn can help mitigate some of this load by serving cached pages, there is a risk of delivering outdated or non-personalized data if the application relies heavily on dynamic content.

Additionally, managing composition and routing on the server side can introduce latency, particularly when the server needs to fetch data from multiple sources before assembling the final page. This added delay can negatively impact the user experience. Furthermore, server-side integration lacks technical isolation within the browser, which can lead to issues such as CSS class name conflicts or global variable collisions in JavaScript.

=== Edge-Side

As an alternative to the server-side method, the edge-side composition and routing occur at the edge of the network, typically within a @cdn. This approach enables micro frontends to be dynamically assembled as close to the user as possible.

Edge networks can handle high traffic more efficiently than central servers by distributing the load across multiple locations. When implemented correctly, this process can be more lightweight than server-side integration, reducing latency and delivering content more quickly to the end user.

However, one of the main challenges with edge-side rendering is ensuring consistent updates across all edge nodes. Inconsistencies in synchronization can result in users in different locations, such as Germany and Vietnam, seeing different versions of the content if updates are not properly coordinated.

It is also important to note that the use cases for edge-side composition are limited and often used along with other patterns, such as server-side composition. While this method is particularly effective for applications requiring rapid delivery and rendering times, its implementation can be complex. The edge-side composition demands advanced infrastructure and expertise to manage effectively, which is why relatively few developers choose to implement micro frontends using this approach, as indicated by a survey on micro frontends conducted in late 2023 @steyer_ConsequencesMicroFrontends_2023.

=== Client-Side

Client-side composition approach can be used in both vertical-split and horizontal-split architectures, where the application view is assembled in the browser and routing logic is also handled on the client-side. This approach is particularly useful for building applications that require significant interactivity and dynamic content.

Since components are loaded and updated in real time, users can interact with the application more fluidly, leading to a more engaging experience. Additionally, offloading the composition task to the client reduces the processing burden on the server. This allows the server to handle more requests or focus on other critical tasks, potentially improving overall system performance.

By handling routing in the browser, once the initial application is loaded, all subsequent navigations are managed by the client. This results in faster transitions between views, as there is no need to reload the entire page from the server. Additionally, client-side routing strategy supports complex routing structures such as flat routing and nested routing.

- Flat Routing: This is a straightforward approach where each route corresponds directly to a specific view without any hierarchy (@figure_flat_nested_routing, left). This creates a one-to-one relationship between the URL and the view, making flat routing simpler to implement, manage, and understand.

- Nested Routing: This allows for more complex route structures by enabling routes to be nested within other routes. A parent route can have one or more child routes, allowing for hierarchical navigation within the application (@figure_flat_nested_routing, right). While nested routing offers greater flexibility, it also adds complexity to the routing logic and requires more careful management of route states.

However, there are challenges associated with this composition. Initial load times can be slower because the browser needs to fetch and render multiple components, resulting in a delay before the user sees the fully assembled interface. Additionally, since the composition task is handled by the client, it can consume more resources on the user's device, which could be an issue for users with less powerful hardware or slower internet connections.

Moreover, when @seo is a major concern, alternative composition methods should be considered. While Googlebot is capable of crawling and indexing client-side rendered pages, not all search engine bots can execute JavaScript. This limitation means that relying on client-side rendering could result in incomplete indexing, potentially reducing the site's visibility across different search engines @_UnderstandJavaScriptSEO_.

#figure(
  image("/assets/flat_nested_routing.png"),
  caption: [Flat and nested routing strategies in client-side routing.],
) <figure_flat_nested_routing>

=== Universal

It is possible to combine client-side and server-side composition to create a more advanced and efficient architecture. In this hybrid approach, the initial view of the application is composed on the server side, which improves performance and reduces the time it takes for the user to first see the web page. Once the initial content is delivered, interactive components are rendered on the client side, enabling dynamic user interactions. This method leverages the strengths of both server-side and client-side composition, ensuring faster initial load times while preserving the engaging, interactive experience that client-side rendering offers. However, implementing this approach is complex due to the need for rendering on both the server and client sides, and it is typically only feasible within a horizontal-split architecture, as the application shell in a vertical-split architecture can only be rendered on the client side.

== Communication <fundamental_communication>

Micro frontends are designed to be independent, modular, and loosely coupled, ideally operating without the need for communication with each other. However, in practice, especially in horizontal-split applications, multiple micro frontends within a single view often need to interact to ensure the correct actions are displayed when a user interacts with the page or to exchange data. This requirement for communication can increase coupling and risk undermining the principle of independent deployment if not implemented carefully. Below are common strategies for enabling communication between micro frontends, each with its specific use cases and considerations:

=== Query Parameters

Using query parameters to pass state through the URL is an effective method for enabling communication between micro frontends. This approach preserves the independence of each micro frontend by limiting their interaction to the URL. The visibility of state in query strings allows users to bookmark or share the page, enhancing the overall user experience. However, this method is most appropriate for handling simple, serializable data types. Overusing query parameters can lead to excessively long and unwieldy URLs. Therefore, this technique should be reserved for simple and transient state sharing between micro frontends, keeping URLs concise and meaningful to avoid unnecessary clutter.

For example, as shown in @figure_vertical_split, when navigating from the product catalog page at `/products` to the product detail page with the URL `/products?id=a1b2c3`, the product team can extract the `id` from the URL and use it to fetch the corresponding product information.

=== Web Storage & Cookies

Web storage and cookies both store data in the browser, allowing any micro frontend to access and share data efficiently. There are two types of saved data: temporary and persistent.

Temporary data includes session storage and session cookies, which are accessible only for the duration of the browser session and are deleted when the browser is closed. Persistent data includes local storage and persistent cookies. Data stored in local storage remains available across sessions and browser tabs and persists until it is explicitly deleted by the user or the application. Persistent cookies, on the other hand, stay on the user's device for a predefined period, such as one hour or one week, before automatically expiring @_WebStorageAPI_2024 @_UsingHTTPCookies_2024.

However, personalized or sensitive data, such as information from an authentication micro frontend, stored in web storage or cookies must be encrypted to ensure security. Careful management is also required to prevent conflicts and ensure data integrity. By using web storage and cookies effectively, micro frontends can maintain their independence while sharing necessary information, thereby enhancing the overall functionality and user experience of the application.

For example, as illustrated in the figure below, two micro frontends can communicate through cookies during a login process. Once the user successfully signs in, the authentication token is encrypted and stored in a cookie. The micro frontend by the team user can then retrieve and decrypt this token to verify the user's authentication status and display the appropriate user data.

#figure(
  image("/assets/storage_cookies.png"),
  caption: [Two micro frontends communicate through cookies during a login process.],
)

=== Event Bus

Another strategy is the event bus, which enables communication between different micro frontends without requiring direct awareness of each other. The event bus operates through two primary mechanisms: event emission and event subscription.

During the event subscription phase, a micro frontend subscribes to specific events on the event bus. The event bus then notifies the subscribing micro frontend whenever another micro frontend emits one of the subscribed events to the bus. For example, in @figure_horizontal_split, when a user selects a different shirt color, the product team emits an event to notify the checkout team that the shirt configuration has changed. As a result, the checkout team will update the price accordingly.

=== Global State Manager

A global state manager becomes especially useful when client-side composition is used. Most frontend frameworks offer state manager libraries, such as Redux #footnote[https://redux.js.org/] for React.js or Pinia #footnote[https://pinia.vuejs.org/] for Vue.js. Similar to communication methods like web storage or an event bus, these tools enable components within a view to communicate more easily and effectively. By centralizing the state, a global state manager allows components to access and update shared states reactively and seamlessly, simplifying the data flow and ensuring a more consistent user experience. However, persisting data still depends on web storage, which has the previously mentioned limitations, as the global state is reset when the page is reloaded.

#pagebreak(weak: true)