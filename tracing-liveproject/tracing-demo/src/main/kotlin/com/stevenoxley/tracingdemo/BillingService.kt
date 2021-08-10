package com.stevenoxley.tracingdemo

import io.opentracing.Span

interface BillingService {
    fun payment(): Unit
}