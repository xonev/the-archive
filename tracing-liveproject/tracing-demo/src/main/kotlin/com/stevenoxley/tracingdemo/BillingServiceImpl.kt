package com.stevenoxley.tracingdemo

import io.opentracing.Span
import io.opentracing.Tracer
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import kotlin.random.Random

@Service
class BillingServiceImpl(@Autowired val tracer: Tracer): BillingService {
    override fun payment(span: Span) {
        val span = tracer.buildSpan("payment").asChildOf(span).start()
        Thread.sleep(Random.nextLong(10, 500))
        span.finish()
    }
}