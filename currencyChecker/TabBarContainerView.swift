//
//  TabBarContainerView.swift
//  currencyChecker
//
//  Created by Adam Makowski on 12/10/2024.
//

import SwiftUI


struct TabBarContainerView<Content:View> : View {
    
    @Binding var selection: TabBarItem
    
    let content: Content
    
    @State var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    var body: some View{
        ZStack(alignment: .bottom){
            content
                .safeAreaInset(edge: .bottom) {
                    TabBarView(tabs: tabs, selection: $selection)
                }
        }
        .onPreferenceChange(TabBarItemPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

#Preview {
    TabBarContainerView(selection: .constant(.home)) {
        Color.blue
    }
}
