package com.stevenoxley.tracingdemo

import io.opentracing.Span
import io.opentracing.Tracer
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import kotlin.random.Random

@Service
class InventoryServiceImpl(@Autowired val tracer: Tracer): InventoryService {
    override fun createOrder(tracingSpan: Span) {
        val span = tracer.buildSpan("createOrder").asChildOf(tracingSpan).start()
        Thread.sleep(Random.nextLong(10, 500))
        span.finish()
    }
}