= Background

This chapter establishes the foundational concepts by first exploring monolithic architecture, the traditional approach to software design. The discussion then moves to the rise of microservices architecture, a significant paradigm shift in backend development that has significantly influenced modern software design. This exploration is extended to the frontend, where similar principles have been adopted. Finally, the chapter introduces the concept of Domain-Driven Design, with a particular focus on its application within the micro frontend architecture.

== Monolithic Architecture

Sam Newman defines a monolith as a deployment unit in which all system functionalities are deployed together. The most common forms of monolithic architectures are the single-process monolith, the modular monolith, and the distributed monolith @newman_BuildingMicroservices2nd_2021.

The single-process monolith represents the most traditional form of monolithic architecture, where all code and functionalities are encapsulated within a single process. In contrast, a modular monolith introduces a level of separation within this single process by dividing it into distinct modules. These modules can be developed independently, thus enabling parallel development efforts. However, they must ultimately be integrated for deployment, which retains the monolithic nature of the application. The distributed monolith, while involving multiple services that can be developed and distributed independently, still requires these services to be deployed together as a unified whole. This need for simultaneous deployment ties the architecture back to monolithic principles, despite the distributed nature of the services.

James Lewis further underscores the simplicity of monolithic architectures @james_Microservices_2014. Because everything runs in a single process, the development, testing, and deployment processes are more straightforward. Developers can run the entire application on their local machines, allowing for thorough testing and ensuring seamless functioning of all components. Additionally, the deployment process itself is simplified, as the entire application is packaged and deployed as a single unit.

However, as applications grow in size and complexity, the limitations of a monolithic architecture become more clear. Even small changes require the entire application to be rebuilt and redeployed, which introduces inefficiencies. The close coupling of components not only slows down the development process but also complicates the updating of individual modules. Over time, maintaining a well-organized and clean codebase becomes increasingly challenging, leading to a structure that is difficult to manage. This growing complexity negatively impacts the system's reliability and maintainability.

Moreover, scaling a monolithic application poses significant challenges. Because the entire application exists as a single unit, scaling necessitates replicating the entire system, even when only a small part of it is needed to scale (illustrated in @figure_scale_monolith_microservice). This approach results in resource inefficiencies and increased costs. In contrast, transitioning to a microservices architecture provides a more flexible and scalable solution for developing complex applications, enabling the scaling of individual components rather than the entire system.

Monolithic architecture can still be a practical and viable option, particularly for smaller organizations or those that do not encounter significant scalability challenges @james_Microservices_2014 @newman_BuildingMicroservices2nd_2021.

#figure(
  image("/assets/scale_monolith_microservice.png"),
  caption: [Comparison between the scalability in monolithic and microservices architecture @james_Microservices_2014.],
) <figure_scale_monolith_microservice>

== Microservices Architecture <section_microservices>

Microservices architecture is an advanced design approach where independent services are developed around specific business requirements. Each microservice is responsible for a particular functionality, enabling the creation of complex systems through the integration of modular components @newman_BuildingMicroservices2nd_2021.

From an external viewpoint, microservices operate as black boxes, delivering business functionality via network endpoints, such as REST APIs. The internal workings of these services are minimally exposed, ensuring that upstream consumers, whether other microservices or external programs, remain unaffected as long as the interfaces remain consistent.

The concept of microservices has been an important subject of research and development for over a decade. Sam Newman identified five key principles that are crucial for understanding the effectiveness of this architectural approach. These principles include independent deployability, designing services around business domains, each service owning its state, and ensuring that the architecture aligns with the organizational structure.

Independent deployability is a core principle of microservices architecture, allowing developers to modify, deploy, and release changes to a microservice without affecting others. Achieving this requires that microservices be loosely coupled, guaranteeing that updates to one service do not necessitate changes in others. This is accomplished by establishing explicit, well-defined, and stable contracts between services.

Building on the idea of independent deployability, modeling microservices around business domains rather than technical layers can further enhance these benefits. @ddd provides a framework for structuring services to mirror real-world domains, thereby simplifying the introduction of new features and functionalities. When services are aligned with business domains, changes usually involve fewer services, which reduces the complexity and cost of updates. The principles of @ddd encourage designing systems that remain flexible and adaptable as business needs change over time.

Another key concept is that each microservice should maintain ownership of its state, interacting with other services only when necessary to obtain data. This separation allows services to manage what data is shared and what remains hidden. By maintaining clear boundaries between internal implementation details and external contracts, this approach minimizes backward-incompatible changes and reduces the potential ripple effects of updates across the system.

Furthermore, aligning the architecture with the organizational structure is essential for the success of microservices. While traditional architectures often mirror the communication patterns within an organization @conway_HOWCOMMITTEESINVENT_1968, a microservices architecture benefits from structuring teams around business domains. This promotes end-to-end ownership of specific functionalities. With this alignment, teams take full responsibility for their services, from development to production, leading to faster and more efficient development processes.

== Micro Frontend Architecture

The concept of micro frontends was first introduced in the ThoughtWorks Technology Radar at the end of 2016, demonstrating how the benefits achieved from microservices in backend development can also be applied to the frontend  @_MicroFrontendsTechnology_.

#figure(
  image("/assets/mono_ms_mfe.png"),
  caption: [A monolithic application is transformed into one composed of microservices and micro frontends.]
) <figure_mono_ms_mfe>

The five key concepts of microservices, as they relate to micro frontends, will also be explored in this discussion. An online shop with different sections, each developed by separate teams, will serve as a practical example to provide greater clarity.

Independent deployability allows each section of the frontend to be developed, tested, and deployed independently of other sections. For example, if the team managing the product detail section needs to introduce a new feature or resolve a bug, they can deploy their changes without affecting the checkout or product recommendation sections.

Micro frontends should also mirror the structure of business domains. Building on concepts of @ddd, each micro frontend corresponds to a specific business function, such as a shopping cart, product catalog, or user authentication. This alignment ensures that changes to business logic are contained within a single micro frontend, simplifying updates and making the system more adaptable to evolving business requirements.

Managing its own state within a micro frontend offers several benefits. It helps maintain loose coupling between different parts of the application. For instance, the shopping cart micro frontend exclusively manages what customers add to their cart, while the product catalog micro frontend controls the display of products. This approach simplifies data flow and makes debugging and testing more straightforward, as each micro frontend has clear boundaries for managing its data.

The final key concept is that teams in a micro frontend architecture are organized around business domains, with each team taking full responsibility for the development of their respective micro frontend. This organizational structure minimizes the need for inter-team coordination and enhances the speed of decision-making processes without waiting for input or approval from other teams.

// However, it is important to note that microservices and micro frontend architectures may not be suitable for all types of backend and frontend applications due to the additional complexity they introduce at both technical and organizational levels. However, these approaches are particularly beneficial in scenarios where multiple teams must collaborate on the same application or when there is a need to gradually replace an existing legacy system.

== Domain-Driven Design <section_ddd>

Domain-Driven Design (DDD) focuses on the division of a large system into smaller, more manageable services. Introduced by Eric Evans in 2003, @ddd provides a structured approach to software development that closely aligns with business goals @eric_DomainDrivenDesignTackling_2003. Although @ddd introduces a wide range of concepts, this summary will concentrate on a few key elements: domain, subdomain, bounded context, and context mapping. These concepts are illustrated through the example of an online shopping application, as shown in @figure_ddd. The application is structured around four main domains, each containing its subdomains and two bounded contexts.

#figure(
  image("/assets/ddd.png", width: 90%),
  caption: [Domain-Driven Design structure of an online shopping application.]
) <figure_ddd>

The domain represents the specific area of knowledge or activity that a software application is designed to address, including all relevant business logic and rules. In the given example, the domains are order, product, user, and payment.

A subdomain is a smaller, specific part within a domain, categorized into three types: core subdomain, supporting subdomain, and generic subdomain. The core subdomain, which is supported by necessary supporting domains, represents the most important part of the business, delivering its unique value and therefore demanding the highest level of attention and custom development. The generic subdomain, on the other hand, is applicable across multiple domains. In the given example, the product detail subdomain supports order processing, which functions as the core subdomain. Additionally, the user authentication subdomain serves as a generic component, designed to be universally used across the application to identify customers.

A bounded context is a defined boundary that separates subdomains within a specific portion of the domain. Within each bounded context, a unique ubiquitous language is used, which may differ from the languages employed in other contexts. In the example, there are two bounded contexts, both containing a subdomain named "detail," but with distinct purposes: one is used for displaying order details, while the other is for displaying product details. Despite these distinctions, relationships can exist between bounded contexts, such as when the order domain requires information from the product domain to process an order. These relationships and interactions between different bounded contexts are referred to as context mapping.

Understanding these concepts is essential for applying @ddd to micro frontends. Further details on how these concepts are implemented in micro frontends will be discussed in @section_decision_framework.

#pagebreak(weak: true)
