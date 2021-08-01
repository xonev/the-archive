package com.stevenoxley.tracingdemo

import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController

@RestController class EShopController() {
    @PostMapping("/checkout") fun checkout(): String = "You have successfully checked out your shopping cart."
}