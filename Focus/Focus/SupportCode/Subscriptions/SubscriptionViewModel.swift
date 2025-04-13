//
//  SubscriptionViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//
import SwiftUI
import Foundation
import StoreKit

@MainActor
class SubscriptionViewModel: ObservableObject {
    @Published var products: [SubscriptionProductItem] = []
    private let isMock: Bool

    @AppStorage("isProUser") var isProUser: Bool = false

    init(mock: Bool = false) {
        self.isMock = mock

        if mock {
            self.products = MockSubscriptionProduct.sampleProducts.map {
                SubscriptionProductItem(product: $0)
            }
        }
    }

    func loadProducts() async {
        guard !isMock else { return } // skip real product loading if mocking

        do {
            let storeProducts = try await Product.products(for: [
                "com.focusapp.pro.monthly.test",
                "com.focusapp.pro.yearly.test"
            ])
            self.products = storeProducts.map {
                SubscriptionProductItem(product: $0)
            }
        } catch {
            print("❌ Failed to load products: \(error)")
        }
    }

    func purchase(productItem: SubscriptionProductItem) async {
        if isMock {
            print("🧪 Simulating purchase of: \(productItem.product.productID)")
            isProUser.toggle()
            return
        }

        guard let storeProduct = productItem.product as? Product else {
            print("❌ Invalid product type")
            return
        }

        do {
            let result = try await storeProduct.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    print("✅ Purchased: \(transaction.productID)")
                    await transaction.finish()
                    isProUser = true
                } else {
                    print("⚠️ Unverified transaction")
                }
            default:
                print("ℹ️ Purchase cancelled or pending")
            }
        } catch {
            print("❌ Purchase failed: \(error)")
        }
    }

    func restorePurchases() async {
        if isMock {
            print("🧪 Simulating restore")
            isProUser = true
            return
        }

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productType == .autoRenewable {
                print("✅ Restored: \(transaction.productID)")
                isProUser = true
                return
            }
        }
    }
}
