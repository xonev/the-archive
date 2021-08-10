package com.stevenoxley.tracingdemo

import io.opentracing.Span
import org.springframework.stereotype.Service

interface InventoryService {
    fun createOrder(): Unit
}