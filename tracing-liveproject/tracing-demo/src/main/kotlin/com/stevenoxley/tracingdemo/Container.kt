package com.stevenoxley.tracingdemo

import io.opentracing.Tracer
import io.opentracing.util.GlobalTracer
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.EnableAspectJAutoProxy

@Configuration
class Container() {
    val tracerConfiguration: io.jaegertracing.Configuration =
        io.jaegertracing.Configuration.fromEnv("TracingDemo")
    @Bean fun tracer(): Tracer = tracerConfiguration.tracer
}