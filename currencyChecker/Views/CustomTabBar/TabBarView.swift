//
//  TabBarView.swift
//  currencyChecker
//
//  Created by Adam Makowski on 12/10/2024.
//

import SwiftUI

struct TabBarView: View {
    
    let tabs: [TabBarItem]
    
    @Binding var selection: TabBarItem
    
    @Namespace private var namespace
    
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        Spacer()
        HStack{
            if !vm.keyboardFocus {
                ForEach(tabs, id: \.self) { tab in
                    tabView(tab: tab)
                        .onTapGesture {
                            changeTab(tab: tab)
                        }
                }
            }
        }
        .padding(6)
        .background(Color("background"))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal,40)
        .padding(.bottom, 10)
    }
}

#Preview {
    let tabs: [TabBarItem] = [.home, .converter, .settings]
    TabBarView(tabs: tabs, selection: .constant(tabs.first!))
        .environmentObject(HomeViewModel())
}

extension TabBarView {
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.symbol)
                .font(.title2)
                .roundedFontDesign()
            Text(tab.title)
                .font(.caption)
        }
        .foregroundStyle(selection == tab ? tab.color : .gray)
        .padding(.vertical, 5)
        .frame(maxWidth: 250)
        .background(
            ZStack {
                if selection == tab {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "TabBarBackground", in: namespace)
                }
            }
        
        )
    }
    
    private func changeTab(tab: TabBarItem) {
        withAnimation(.easeInOut(duration: 0.25)) {
            selection = tab
        }
    }
}


