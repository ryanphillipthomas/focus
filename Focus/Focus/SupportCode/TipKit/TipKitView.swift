//
//  TipKitView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/20/25.
//
import SwiftUI
import TipKit

struct TipKitView: View {
    let popoverTip = PopoverTip()
    let inlineTip = InlineTip()

    var body: some View {
        
        List() {
            Section(header: Text("Tips")) {
                Button("Popover Tip") {
                    // your action
                }.popoverTip(popoverTip)
                TipView(inlineTip)
            }
            Section(header: Text("Advanced")) {
                Button("Reset Tips") {
                    TipKitManager.shared.reset()
                }
            }
        }
    }
}
