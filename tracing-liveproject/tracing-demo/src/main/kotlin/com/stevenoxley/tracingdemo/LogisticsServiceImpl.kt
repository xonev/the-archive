package com.stevenoxley.tracingdemo

import io.opentracing.Span
import io.opentracing.Tracer
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import kotlin.random.Random

@Service
class LogisticsServiceImpl(@Autowired val tracer: Tracer): LogisticsService {
    override fun transport() {
        val span = tracer.buildSpan("transport").start()
        tracer.activateSpan(span).use {
            Thread.sleep(Random.nextLong(10, 500))
        }
        span.finish()
    }
}