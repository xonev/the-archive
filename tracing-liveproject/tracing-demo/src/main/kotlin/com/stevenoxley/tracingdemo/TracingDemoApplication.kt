package com.stevenoxley.tracingdemo

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class TracingDemoApplication

fun main(args: Array<String>) {
	runApplication<TracingDemoApplication>(*args)
}
