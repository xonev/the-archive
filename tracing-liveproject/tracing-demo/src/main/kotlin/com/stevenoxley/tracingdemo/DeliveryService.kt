package com.stevenoxley.tracingdemo

import io.opentracing.Span

interface DeliveryService {
    fun arrangeDelivery(span: Span): Unit
}