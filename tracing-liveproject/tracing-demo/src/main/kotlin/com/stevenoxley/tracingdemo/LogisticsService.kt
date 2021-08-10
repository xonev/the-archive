package com.stevenoxley.tracingdemo

import io.opentracing.Span

interface LogisticsService {
    fun transport(span: Span): Unit
}