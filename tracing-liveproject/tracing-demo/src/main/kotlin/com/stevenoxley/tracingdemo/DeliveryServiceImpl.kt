package com.stevenoxley.tracingdemo

import io.opentracing.Span
import io.opentracing.Tracer
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import kotlin.random.Random

@Service
class DeliveryServiceImpl(@Autowired val tracer: Tracer,
                          @Autowired val logisticsService: LogisticsService): DeliveryService {
    override fun arrangeDelivery(span: Span) {
        val span = tracer.buildSpan("arrangeDelivery").asChildOf(span).start()
        logisticsService.transport(span)
        Thread.sleep(Random.nextLong(10, 500))
        span.finish()
    }
}