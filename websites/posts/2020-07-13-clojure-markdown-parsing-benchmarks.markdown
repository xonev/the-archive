---
layout: post
title: "Clojure Markdown Parsing Benchmarks"
date: 2020-07-13 10:45:32 -0700
comments: true
categories: clojure programming
---

I am working on setting up a new system for publishing content. I have a few different categories of content that I'm interested in creating. I'll have to determine exactly what the taxonomy will be, but the broad categories will probably be computers, mountain biking, and more personal stuff including relationships and religion. The first step towards this new system is just to replace the technology behind this website.

This website is currently generated statically using a very old version of [jekyll](https://jekyllrb.com/)/[octopress](http://octopress.org/). Static site generation is really nice, but I think I'm going to want to add some more interactive features like small applications. Therefore, I decided to replace this static site generation approach with a Clojure application.

Since these posts currently are all written in markdown and then parsed and rendered into HTML before being served statically via nginx, I wanted to check to see how expensive it would be to parse and render the markdown into HTML on every page load. To evaluate, I used a couple of handy Clojure libraries - [markdown-clj][1] and [criterium][2]. Using `markdown-clj` it was fairly trivial to replicate the functionality of the markdown processing of octopress. It is even has the ablility to parse the metadata at the top of the markdown files. For example, this is the metadata that I have at the top of this post:

```
---
layout: post
title: "Clojure Markdown Parsing Benchmarks"
date: 2020-07-13 10:45:32 -0700
comments: true
categories: clojure programming
---
```

To parse that metadata, I simply had to pass in the `:parse-meta? true` option when parsing, like this:

```
(md/md-to-html file-name writer :parse-meta? true :reference-links? true)
```


[1]: https://github.com/yogthos/markdown-clj
[2]: https://github.com/hugoduncan/criterium/
[3]: https://github.com/hugoduncan/criterium/issues/41
[4]: https://github.com/xonev/the-archive/blob/4fbdbcc8f08386a9ef893a21d69c2b74385c5ecf/websites/src/websites/markdown.clj
[5]: https://github.com/xonev/the-archive/blob/4fbdbcc8f08386a9ef893a21d69c2b74385c5ecf/websites/src/websites/core.clj
