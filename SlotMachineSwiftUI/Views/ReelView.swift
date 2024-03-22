//
//  ReelView.swift
//  SlotMachineSwiftUI
//
//  Created by Rustam Keneev on 22/3/24.
//

import SwiftUI

struct ReelView: View {
    var body: some View {
        Image("gfx-reel")
            .resizable()
            .modifier(ImageModifier())
    }
}

#Preview {
    ReelView()
        .previewLayout(.fixed(width: 220, height: 220))
}
