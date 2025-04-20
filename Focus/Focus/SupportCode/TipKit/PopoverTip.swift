//
//  StartFocusTip.swift
//  Focus
//
//  Created by Ryan Thomas on 4/20/25.
//


import TipKit

struct PopoverTip: Tip {
    var title: Text {
        Text("Popover Tip")
    }

    var message: Text? {
        Text("This is an example of a popover tip.")
    }

    var image: Image? {
        Image(systemName: "clock")
    }
}
