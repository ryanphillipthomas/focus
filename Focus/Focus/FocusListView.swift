import SwiftUI
import SwiftData

struct FocusListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationView {
            Group {
                if items.isEmpty {
                    VStack {
                        Spacer()
                        Text("No focus items yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(backgroundColor)
                } else {
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                ItemDetailView(item: item)
                            } label: {
                                HStack {
                                    Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                                    Spacer()
#if os(macOS)
                                    Button {
                                        deleteItem(item)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.borderless)
#endif
                                }
                            }
                        }
#if os(iOS)
                        .onDelete(perform: deleteItems)
#endif
                    }

                    .background(backgroundColor)
#if os(iOS)
                    .listStyle(.insetGrouped)
#endif
                }
            }
            .navigationTitle("Focus List")
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: addItem) {
                        Label("Add", systemImage: "plus")
                    }
                }
#else
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add", systemImage: "plus")
                    }
                }
#endif
            }
        }
    }

    private func deleteItem(_ item: Item) {
        withAnimation {
            modelContext.delete(item)
        }
    }

    private var backgroundColor: some View {
#if os(iOS)
        return Color(.systemGroupedBackground)
#else
        return Color(nsColor: .windowBackgroundColor)
#endif
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)

            do {
                try modelContext.save()
            } catch {
                print("❌ Failed to save item: \(error)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}
