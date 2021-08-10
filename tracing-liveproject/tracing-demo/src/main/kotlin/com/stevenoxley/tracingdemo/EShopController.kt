package com.stevenoxley.tracingdemo

import io.opentracing.Tracer
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController

@RestController class EShopController(
    @Autowired val tracer: Tracer,
    @Autowired val inventoryService: InventoryService,
    @Autowired val deliveryService: DeliveryService,
    @Autowired val billingService: BillingService) {
    @PostMapping("/checkout") fun checkout(): String {
        val span = tracer.buildSpan("checkout").start()
        val scope = tracer.scopeManager().activate(span)
        scope.use {
            println("Doing some checkout activities")
            inventoryService.createOrder()
            billingService.payment()
            deliveryService.arrangeDelivery()
        }
        span.finish()
        return "You have successfully checked out your shopping cart."
    }
}