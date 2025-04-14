import SwiftUI

struct SubscriptionListView: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            if viewModel.products.isEmpty {
                HStack {
                    Spacer()
                    ProgressView("Loading subscriptions...")
                    Spacer()
                }
            } else {
                Section(header: Text("Status")) {
                    HStack {
                        Label("Status", systemImage: viewModel.isProUser ? "checkmark.seal.fill" : "xmark.seal")
                        Spacer()
                        Text(viewModel.isProUser ? "Paid" : "Free")
                            .foregroundColor(viewModel.isProUser ? .green : .secondary)
                    }
                }
                
                Section(header: Text("Choose Your Plan")) {
                    ForEach(viewModel.products) { item in
                        let product = item.product
                        VStack(alignment: .leading, spacing: 6) {
                            Text(product.name)
                                .font(.headline)
                            Text(product.price)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Button("Subscribe") {
                                Task {
                                    await viewModel.purchase(productItem: item)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }

            Section {
                Button("Restore Purchases") {
                    Task {
                        await viewModel.restorePurchases()
                    }
                }
            }
        }
        .navigationTitle("Manage Subscription")
        .analyticsScreen(self)
        .task {
            if viewModel.products.isEmpty {
                await viewModel.loadProducts()
            }
        }
    }
}



struct SubscriptionListView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionListView(viewModel: SubscriptionViewModel(mock: true))
            .previewDisplayName("Subscription List (Mock)")
    }
}
