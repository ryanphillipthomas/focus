//
//  StartFocusTip.swift
//  Focus
//
//  Created by Ryan Thomas on 4/20/25.
//


import TipKit

struct InlineTip: Tip {
    var title: Text {
        Text("Inline Tip")
    }

    var message: Text? {
        Text("This is an example of a inline tip.")
    }

    var image: Image? {
        Image(systemName: "book")
    }
}
