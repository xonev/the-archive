---
title: "Is Your Code Review Effective?"
description: "The number one thing I think makes for an excellent code review."
tags: ["code review"]
date: 2023-07-31T17:11:30-07:00
images: ["/articles/understand-code-bing-generated.jpeg"]
---

In this next installment of my series on code review (the [first article](/articles/why-do-code-review-at-all.html) was about why we do code review in the first place), we'll be looking at how to review code effectively. There are several practices that I think make code review effective. In this article I want to focus on one particular one that -- if you're not doing it already -- will dramatically increase the effectiveness of your code review. Next time, we'll go over some other practices to make code review more effective, but before we get to any of that let's talk about how the lightweight peer review we use today came to be.

![Cartoon of an engineer trying to understand code](/articles/understand-code-bing-generated.jpeg)

## Formal Inspections vs. Peer Review

The informal code review process many of us follow today evolved as a lighter-weight version of [formal inspections](https://en.wikipedia.org/wiki/Fagan_inspection). Formal inspections are very focused on (and effective at) finding defects, involve a synchronous meeting, require rules about different phases of the inspection process, have specific assigned roles, etc. And, as you might have gathered by now, no one really does them anymore because they are expensive and slow. Instead, the light weight peer review that many of us know and love today is an attempt at keeping the most effective practices from formal inspections and dropping the stuff that slows things down.

Fortunately, research seems to indicate that lighter weight code review processes have a similar effectiveness at finding defects (see Rigby and Bird's paper [*Convergent contemporary software peer preview practices*](https://www.researchgate.net/publication/262328269_Convergent_contemporary_software_peer_review_practices) for more details). And as we saw in [*Why Do Code Review at All?*](/articles/why-do-code-review-at-all.html), finding defects is not the only benefit of code review. So how do we make sure this lighter weight process still gets us all those sweet benefits?

## Understand the Code

Understand the code you're reviewing. Actually take the time to truly understand it. It sounds simple, but this is the number one advice I think I can give on the subject. It's not something you can easily measure, so it's unlikely to come up in the research, and yet it's probably the main thing that separates a "meh" review from a truly excellent review.

If you're honest with yourself, I'm sure you can think of times where you've scanned through a pull request looking for anything obvious to jump out at you without seriously trying to understand how the code works. I know I have. Hillel Wayne even [gave it a name](https://buttondown.email/hillelwayne/archive/code-review-vs-code-proofreading/): proofreading. There are multiple reasons why someone might do a cursory review -- merging the code in question is time-sensitive, they don't have the energy to truly dig in, they're avoiding the brain pain of a thorough review, etc. -- but when they make that compromise they won't reap most of the benefits of code review.

Some of the best reviews I've seen were from colleagues who really dug into every aspect of the code under review. In one example, I remember my colleague leaving a comment on my pull request pointing out that there was a bug reported against one of the library functions I was using. I hadn't even seen that bug report, and I wrote the code! I was so taken aback I asked him how he found it. His answer: he had come across the bug report while doing research to learn the library function.

So how do you make sure you're understanding the code? Read it carefully, thinking through how the code would run in your head. Write down some notes if you need to. Definitely leave comments for the author with questions about anything that confuses you. Look up documentation for any libraries, APIs, or language features that you're not familiar with. In my experience, when reviewing a complicated change my head might hurt a bit at the beginning, but once I start to dig in the code starts to open up to me and I start to see how the code fits together as well as opportunities for improvement.

## Try It

I challenge you to consciously make sure you're understanding the code the next time you do a review. See how it changes the number of things you notice. See if it helps you gain more knowledge which you can use in the future. Next time, we'll talk about some more practices that will help your whole team be better at code review.

In the meantime, you can sign up for the Nudgsicle newsletter below. Then reply to the welcome email I'll send with any practices you think make for great code review!

<script async src="https://eomail6.com/form/a9d5dfbc-2259-11ee-8e25-abc8bf461d43.js" data-form="a9d5dfbc-2259-11ee-8e25-abc8bf461d43"></script>