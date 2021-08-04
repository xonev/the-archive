package com.stevenoxley.tracingdemo

import io.opentracing.Tracer
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController

@RestController class EShopController(@Autowired val tracer: Tracer) {
    @PostMapping("/checkout") fun checkout(): String {
        val span = tracer.buildSpan("checkout").start()
        println("Doing some checkout activities")
        span.finish()
        return "You have successfully checked out your shopping cart."
    }
}