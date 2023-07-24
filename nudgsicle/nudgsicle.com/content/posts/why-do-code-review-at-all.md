---
title: "Why Do Code Review at All?"
description: "Describing the benefits of code review."
tags: ["code review"]
date: 2023-07-20T22:01:29-07:00
---

Code review -- at least the type of code review I'm talking about in this blog series -- is the process of asynchronously examining and commenting on someone else’s code before it is merged into the main branch of your source control repo. It is a common practice in software development, but why do we do it? Should we do it? What are the benefits of code review?

# Review Code for Software Quality

One of the main reasons to do code review is to improve the quality of the software we produce. There are several aspects to software quality including maintainability, lack of defects, and performance.

Imagine this scenario. You are working on a feature that requires you to add some functionality to a core component of your system. You start looking at the code in the area you'll be working, and you realize that it is a mess. The code obviously works -- it's been in production for weeks -- but it's tightly coupled with other components of the system, making it difficult for you to modify.

You wonder who wrote this code, and you check the commit history. You see that it was written by one of your colleagues and was pushed directly to the main branch without any code review. It worked, so he shipped it.

This is an example of how lack of code review can lead to poor software quality. If your colleague had asked someone to review his code before merging it, they might have pointed out the tight coupling and suggested some improvements or refactoring. But because he skipped code review, he ended up creating a lot of technical debt and making your life harder.

I think that code review particularly excels at identifying issues with code maintainability. Maintainable code is easy to read, change, or reuse.

Issues with maintainability can be hard to detect by automated testing, linting, or other similar methods, because these methods usually focus on the functionality or syntax of the code, not the design or structure. Poor maintainability can affect the code’s performance, reliability, or security in subtle or indirect ways that are not easy to measure or test.

Poorly designed architecture -- especially tight coupling (where part of the code cannot be changed without also changing something else), and low cohesion (where somewhat unrelated pieces of code are all bundled together) are frequent causes of poor maintainability, but code review is uniquely equipped to find these issues because experienced engineers develop an intuition for recognizing these problems. The reviewers can also provide a unique perspective when they think about how they may have to reuse or modify the code in the future. The reviewers can broaden the total perspective on how the code fits in with the other parts of the system, since each engineer will likely have different levels of experience with different parts of the system.

Another frequent cause of poor maintainability -- lack of consistency -- is also often found during code review. An unusual variable name that does not follow your team's normal conventions can easily cause confusion, and these types of issues are often identified and remedied during code review.

Code review has also been proven to be effective at removing good old-fashioned defects from software. A recent [study by McIntosh et al](https://dl.acm.org/doi/10.1145/2597073.2597076) found that "Low code review coverage and participation are estimated to produce components with up to two and five additional post-release defects respectively." They further claimed, "Our results empirically confirm the intuition that poorly reviewed code has a negative impact on software quality in large systems using modern reviewing tools." In the venerable book *Code Complete*, Steve McConnell cites a study by NASA that found that code reading (which is very similar to the asynchronous, informal review that most companies do today) "detected about 3.3 defects per hour of effort. Testing detected about 1.8 errors per hour (Card 1987). Code reading also found 20 to 60 percent more errors over the life of the project than the various kinds of testing did."

It's been proven time and again that code review increases software quality, but that may not even be the biggest benefit of code review.

# Review Code for Knowledge Sharing

Another reason to do code review is to facilitate knowledge sharing among developers.

Imagine this scenario. One of your teammates goes on vacation for two weeks. During her absence, you encounter a critical issue in her area of responsibility. You have to dig into her code to figure out what is going on and how to fix it. However, you find that her code is unfamiliar and complex. She did not share her design decisions or logic in her pull requests. She also did not involve anyone else in her development process, making her code exclusive and obscure.

Her code is well-written, well-documented, and well-structured, but you have no context or background on how it works or why it works that way. You try to contact her, but she is unreachable. You spend hours trying to understand her code and solve the problem, but you only make slow progress. You end up wasting a lot of time and resources.

This is an example of how lack of code review can lead to poor knowledge sharing among developers. If your teammate had asked someone to review her code before merging it, they might have learned from her design decisions and logic in her pull requests. They might have also provided some feedback or suggestions to improve her code or make it more accessible. But because she skipped code review, she ended up keeping her knowledge to herself and creating a knowledge gap.

This is an example of how code review can bring the specific benefit of improving the [bus factor](https://en.wikipedia.org/wiki/Bus_factor) on a project. In other words, code review helps spread knowledge such that if there's a problem anywhere in the code then there should be multiple people familiar enough with the area of the code where the problem lies to fix it.

Code review can also help us suggest best practices and patterns in our code. By giving constructive feedback and recommendations, we can help each other improve our coding skills and learn new techniques or technologies.

Code review can also help us show less experienced developers examples of good code and explain why they are good. This is one reason why it's important for both less experienced and the most experienced developers both have their code reviewed.

So knowledge sharing is another big benefit of code review, but there's one aspect of code review that some might list as a benefit, which I think is an antipattern.

# Do Not Review Code to Gatekeep

Code review is not for gatekeeping. At the risk of exaggerating slightly, I don't think it's the responsibility of the code reviewer to keep changes from being merged until they're "good enough" or up to the standard of the reviewer. In the worst cases, code review can be misused as a way of imposing your own solutions or approaches on others, or nitpicking stylistic stuff that does not affect the functionality or quality of the code.

Imagine this scenario. You are working on a feature that added some logging functionality to your system. You had to modify some files that were part of the core component of the system that handled the orders. You tested your code and created a pull request to merge it into the main branch.

However, one of your colleagues, who was a senior developer and the owner of the core component, kept rejecting your pull request. He said that you should use a different logging library, or that you should format your code differently, or that you should add more comments. He did not provide any valid reasons for his suggestions, nor did he recognize the benefits of your solution. He just wanted you to do it his way.

This would not only be frustrating and demotivating for you, but also counterproductive and wasteful for the project. Code review should be a collaborative and respectful process, not a confrontational and authoritarian one.

When code review is at it's best, the reviewer will approach the review as an opportunity to help their colleague. That's why I often leave suggestions on pull requests and then approve them without waiting for any response from the author of the pull request. This helps to show that the reviewer isn't in a position of authority -- everyone is working together to make the code better.

To be clear, I do still think it's appropriate to request changes or "reject" a pull request if there are obvious defects found. But it should generally be assumed that the author of the pull request will want to fix any defects just as much as the reviewer does. So in some ways requesting changes isn't even strictly necessary.

One piece of data to support this approach to review is the findings of the [DevOps Research and Assessment (DORA) program](https://dora.dev/). They found that Change Advisory Boards (CAB), which are formal review processes specifically designed to gatekeep (by my interpretation), have no detectable positive effect. To quote [their research page](https://dora.dev/research/),

> Our research shows that formal change management processes that require the approval of an external body such as a change advisory board (CAB) or a senior manager have a negative impact on software delivery performance. Furthermore, we found no evidence to support the hypothesis that a more formal approval process is associated with lower change fail rates.

# Do Review Code

To summarize, code review is a valuable practice that can bring many benefits to software development. So you should absolutely do it if you're writing professional software. It can help us improve the quality of our software, share knowledge among developers, and foster a culture of collaboration and learning.

In order to review code effectively, it's also very important to take it seriously and follow good practices, and that will be the topic of my next post!

If you'd like to be notified about future posts and Nudgsicle -- the new product that I'm creating to help shorten the time from code written to code reviewed -- sign up for the Nudgsicle mailing list below.

<script async src="https://eomail6.com/form/a9d5dfbc-2259-11ee-8e25-abc8bf461d43.js" data-form="a9d5dfbc-2259-11ee-8e25-abc8bf461d43"></script>

# A Bad Estimate

Why do code review at all?

Imagine you're starting on a new feature in your web application product at your day job. In the planning meeting earlier in the week, you estimated that this feature was about 2 story points. You figure it will take you a few hours to get the happy path working and then you can spend the rest of the day writing tests, figuring out edge cases, etc. You expect to have the feature completed by the end of the day... Until you start digging into the code. Soon you realize that none of this code works the way you thought it would. Your teammate was working in this area last week. You thought you'd be able to reuse his code, but apparently he decided it would be a good idea to implement the backend of his feature as one giant function that fills several screens as you scroll your IDE. You'll need to spend the rest of the day pulling apart this code and refactoring into reusable pieces. There's no way you'll be done by the end of the day, and now you're not sure you'll make it to the other features you were expecting to finish this week.

## Review Code for Software Quality

You've been a victim of low quality software.

Undoubtedly the number one reason to review code is to increase the quality of the software under development. There are a few different aspects to software quality, and code review can help with each of them, though it's better suited for some than others.

### Maintainability and Architecture Quality

The story of your colleague writing one big function to implement a feature is an example of low quality due to lack of maintainability. Even if the software is correct and performs well it can still be low quality if it's impossible to add new features, fix defects, etc. Code review is excellent at finding these types of problems. It's difficult as an individual to think of all the different possibilities for how the code you're writing will be changed or reused in the future. In the story, it would be obvious that the giant function needs to be refactored. Often, code review will catch much more subtle issues, since multiple people with diverse perspectives are looking at the same piece of code from different angles and with different context.

Code review is also especially valuable for finding issues with maintainability and architecture because tooling and tests aren't nearly as effective at finding these issues with code.
- Software quality - story about making a change to some code and finding the code needs refactoring, re-architecting
    - removing defects - certain types of defects, usually higher-level design defects, are more likely to be found by code review. Other types of defects are more likely to be found by tests.
    - making code consistent and understandable
    - identifying maintainability or architecture issues
    - https://www.philipotoole.com/code-reviews-still-rule/
    https://dl.acm.org/doi/10.1145/2597073.2597076
    > Low code review coverage and participation are estimated to produce components with up to two and five additional post-release defects respectively. Our results empirically confirm the intuition that poorly reviewed code has a negative impact on software quality in large systems using modern reviewing tools.


# A Missing Colleague

## Review Code for Knowledge Sharing
- Knowledge sharing - story about someone going on vacation and having to dig into unfamiliar code to figure out the issue
    - reducing the bus factor
    - suggesting best practices and patterns in the code
    - showing less experienced developers examples of good code

# The Unmerged Pull Request

## Do Not Review Code to GateKeep
- Code review is not for gatekeeping - story about trying to get a pull request merged
    - making people use your solutions or approaches
    - nitpicking stylistic stuff
    - https://dora.dev/devops-capabilities/process/streamlining-change-approval/

