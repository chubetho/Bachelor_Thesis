= Summary

== Conclusion

TODO

This study is guided by the following primary research questions:

- How does adopting microfrontend architecture specifically affect the scalability, maintainability, flexibility, and performance of a web application?

- Can the microfrontend approach effectively mitigate the specific challenges and limitations inherent in the current monolithic architecture of the @dklb project?


== Future Research

The experiment effectively demonstrates how a microfrontend architecture could be adopted by the DKLB project, showcasing its potential in this context. However, to fully realize the benefits of this approach, several optimizations are necessary, particularly in bundle analysis. For instance, an examination of the network tab for the microfrontend application revealed duplicate dependencies, which contribute to an increased JavaScript payload size and, consequently, could impact performance.

To address these issues, Rspack could be utilized as the bundler, given its official support for Module Federation. This contrasts with Vite, which currently relies on a third-party plugin that is no longer maintained. The choice of Rspack is further strengthened by its ongoing collaboration with the creator of Module Federation to release Module Federation 2.0, which is expected to introduce numerous features and performance enhancements. Additionally, Rolldown, the successor to Vite, is anticipated to enter public beta by the end of this year, offering native support for Module Federation as one of its key features. These advancements could significantly reduce the performance overhead typically associated with microfrontends, potentially bringing their efficiency closer to that of a monolithic architecture, thereby making the microfrontend approach more viable for the DKLB project.

#pagebreak(weak: true)