//
//  SubscriptionProduct.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//
import StoreKit

protocol SubscriptionProduct {
    var productID: String { get }
    var name: String { get }
    var price: String { get }
}


extension Product: SubscriptionProduct {
    var productID: String { self.id }
    var name: String { displayName }
    var price: String { displayPrice }
}


struct MockSubscriptionProduct: SubscriptionProduct {
    let productID: String
    let name: String
    let price: String

    static let sampleProducts: [MockSubscriptionProduct] = [
        .init(productID: "com.focusapp.pro.monthly.test", name: "Focx Pro (Monthly)", price: "$4.99"),
        .init(productID: "com.focusapp.pro.yearly.test", name: "Focx Pro (Yearly)", price: "$39.99")
    ]
}

struct SubscriptionProductItem: Identifiable {
    var id: String { product.productID }
    let product: any SubscriptionProduct
}


