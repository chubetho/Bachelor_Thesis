#import "@preview/glossarium:0.4.1": glspl 

= Introduction

In the early days of the World Wide Web, the frontend was relatively simple. The first website, published in 1991 by British scientist Tim Berners-Lee while working at The European Organization for Nuclear Research (CERN) @_BirthWebCERN_, was a basic, static webpage created using @html. These early static websites were hosted on servers with content that remained unchanged unless manually updated by a webmaster. The level of interactivity was minimal, primarily focused on displaying information in a straightforward, text-based manner. As the web evolved, the complexity and expectations of web applications grew, leading to the development of more sophisticated and interactive frontend designs.

Today, a variety of modern methodologies have been developed to meet the diverse needs of different projects. One of the most notable approach is single-page application, which offers a highly interactive user experience characterized by fast loading times and smooth transitions. Despite these benefits, @spa often falls short in terms of performance compared to traditional server-side rendering, particularly concerning speed and @seo. A hybrid approach that effectively combines the strengths of both methodologies is universal rendering. This approach starts by rendering the application on the server, which results in faster load times and improved @seo. Following this initial load, the client-side manages subsequent interactions, thereby maintaining the high level of interactivity characteristic of #glspl("spa").

Despite these advancements, as the functionality of a frontend application grows, it becomes a complex and large structure. This growth leads to challenges in scaling and maintaining large-scale applications, especially when multiple teams are involved in development. This issue stands in contrast to the backend, which has increasingly adopted the microservices architecture over the past decade. In this architectural style, the backend is divided into smaller, independently deployable services, enhancing flexibility, scalability, and ease of maintenance.

The frontend of a web application functions as the presentation layer that users initially see and interact with, including everything users experience visually and navigate through such as layouts, buttons, images, and forms. A well-designed frontend not only ensures that the application is visually appealing but also guarantees responsiveness, reliability, and ease of use. Because of its direct effects on user experience and satisfaction, frontend development has become a critical and complex task that companies must approach with thorough attention.

== Motivation

The motivation behind this study arise from the challenges faced by the @dklb website, a platform for online lottery services, allowing users to participate in various lottery games and access related information provided by LOTTO Berlin @_LOTTOBerlin_. This web application, originally developed in 2014, is based on an outdated monolithic architecture. Although this architectural design was effective and sufficient at that time, it has since fallen behind modern standards, leading to a series of critical issues that demand consideration.

One of the primary issues is the lack of flexibility. Since all components of the system are tightly interconnected, updating or modifying any individual part requires redeployment of the entire application. This process is time-consuming and introduces the risk of potential downtime, which negatively affects user experience and business operations.

Maintainability is another major drawback. As this legacy system ages, maintaining it has become increasingly complex and error-prone. Extensive testing and coordination are required to ensure changes do not cause new problems elsewhere in the application. Furthermore, the reliance on old technologies and a large codebase makes it challenging to attract skilled developers and poses difficulties for new junior developers who may struggle to explore and understand the codebase. Theses factors collectively slow down development cycles and delay the release of new features.

Additionally, the current frontend architecture of @dklb project is misaligned with agile development practices. The tight coupling of components prevents parallel development efforts and continuous integration, as teams are unable to work independently on different parts of the application. This misalignment further underscores the urgent need for a modern architectural approach that can address the limitations of the current system.

== Objective

In response to the challenges faced by the current application, MULTA MEDIO, the company responsible for its development and maintenance, has decided to undertake a complete rewrite of the application. A central concern in this process is the selection of an appropriate frontend architecture. With the growing interest in microfrontend architecture and its benefits, as demonstrated by many leading companies, this study aims to explore the feasibility and potential advantages of adopting this approach for the @dklb application. The results of this investigation are intended to provide in-depth insights and a thorough analysis, which inform the decision-making process regarding the architectural transition.

This study is guided by the following primary research questions:

- How does adopting microfrontend architecture specifically affect the scalability, maintainability, flexibility, and performance of a web application?

- Can the microfrontend approach effectively mitigate the specific challenges and limitations inherent in the current monolithic architecture of the @dklb project?

To address these questions, a comprehensive experiment, including multiple stages from planning to deployment, will be conducted. This experiment will serve as a proof of concept, designed to replicate a real-world project scenario in order to evaluate the impact of the proposed microfrontend architecture on the identified aspects.

== Structure

This study on microfrontend architecture is structured into eight chapters, each building upon the previous to provide a comprehensive exploration of the subject. The first chapter, which concludes here, introduces the study and outlines its objectives. The second chapter explains the monolithic architecture, the transition to microservices architecture in the backend and how this shift has inspired similar trends in frontend development. It also introduces the concept of Domain-Driven Design, particularly in the context of microfrontends. With this foundational understanding established, chapter three presents a state-of-the-art review, examining the motivations behind the adoption of microfrontend architecture through both academic research and practical case studies.

Chapter four then utilizes a decision framework to guide the selection of the most appropriate approaches for implementing microfrontends, which are further detailed in chapter five. Chapter six offers a comprehensive experiment that demonstrates the multiple stages of implementing microfrontend architecture within the context of the @dklb project. The evaluation of this experiment, including a discussion of the advantages and disadvantages of microfrontend architecture, is the focus of chapter seven. Finally, chapter eight addresses the study's limitations, suggests directions for future research, and provides a concluding summary of the findings.

#pagebreak(weak: true)
