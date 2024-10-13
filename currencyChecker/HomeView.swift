//
//  ContentView.swift
//  currencyChecker
//
//  Created by Adam Makowski on 24/04/2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @State var showSettings: Bool = false
    @State var showSearchBar: Bool = true
    @State var tabSelection: TabBarItem = .home
    
    var body: some View {
        if vm.dataLoaded {
            TabBarContainerView(selection: $tabSelection) {
                
                homeView
                .tabBarItem(tab: .home, selection: $tabSelection)
                
                ConverterView(inputCurrency: vm.mainRate,
                              outputCurrency: vm.mainRate)
                .tabBarItem(tab: .converter, selection: $tabSelection)

                SettingsView()
                    .tabBarItem(tab: .settings, selection: $tabSelection)
            }
        }
        else {
            VStack{
                Text("Loading currency data...")
                    .font(.title.weight(.heavy))
                    .padding()
                if vm.loading{
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("background"))
                                .shadow(radius: 5)
                                .frame(width: 250, height: 60)
                        )
                }
                else {
                    Button {
                        vm.fetchData(table: "A")
                        vm.fetchData(table: "B")
                    } label: {
                        HStack{
                            Text("Refresh")
                                
                            Image(systemName: "arrow.2.circlepath")
                        }
                        .font(.headline.weight(.semibold))
                        .tint(.primary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("background"))
                                .shadow(radius: 5)
                                .frame(width: 250, height: 60)
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("background"))
        }
    }
}

extension HomeView {
    
    private var defaultView: some View {
        TabView{
            ZStack {
                
                Color.background.ignoresSafeArea(.container, edges: .top)
                
                VStack {
                    topBar
                    
                    List{
                        if !filteredFavouritesRates.isEmpty{
                            Section {
                                favouritesView
                            } header: {
                                headerText(text: "Favourites")
                            }
                        }
                        
                        if !filteredExchangeRates.isEmpty{
                            Section {
                                currenciesList
                            } header: {
                                headerText(text: "\(vm.tableDate ?? "")")
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    
                }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            ConverterView(inputCurrency: vm.mainRate,
                          outputCurrency: vm.mainRate)
            .tabItem {
                Label("Converter", systemImage: "arrow.left.arrow.right.square")
            }
            SettingsView()
                .tabItem{
                    Label("Settings", systemImage: "gear")
                }
        }
    }
    
    private var homeView: some View {
        ZStack {
            
            Color.background.ignoresSafeArea(.container, edges: .top)
            
            VStack {
                topBar
                
                List{
                    if !filteredFavouritesRates.isEmpty{
                        Section {
                            favouritesView
                        } header: {
                            headerText(text: "Favourites")
                        }
                    }
                    
                    if !filteredExchangeRates.isEmpty{
                        Section {
                            currenciesList
                        } header: {
                            headerText(text: "\(vm.tableDate ?? "")")
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                
            }
        }
    }
    
    
    private var topBar: some View {
        
        TextField("\(Image(systemName: "magnifyingglass")) Search currencies", text: $vm.searchText)
            .padding()
            .background()
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding(.horizontal)
            .overlay(alignment: .trailing) {
                if !vm.searchText.isEmpty {
                    Button {
                        vm.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .tint(.primary)
                            .font(.title3)
                    }
                    .padding(.horizontal, 30)
                }
            }
    }
    
    private var favouritesView: some View {
        ForEach(filteredFavouritesRates) { rate in
            
            
            CurrencyRowView(rate: rate)
                .contextMenu {
                    Button(action: {
                        withAnimation {
                            vm.deleteFromFavourites(rate: rate)
                        }
                    })
                    {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Remove from favourite")
                        }
                    }
                }
        }
    }
    
    var filteredExchangeRates: [ExchangeRate] {
        if vm.searchText.isEmpty {
            return vm.exchangeRates.filter { rate in
                !vm.favouriteCurrencies.contains(rate)
            }
        } else {
            return vm.exchangeRates.filter { rate in
                (rate.currency.lowercased().contains(vm.searchText.lowercased()) ||
                 rate.code.lowercased().contains(vm.searchText.lowercased())) &&
                !vm.favouriteCurrencies.contains(rate)
            }
        }
    }
    
    var filteredFavouritesRates: [ExchangeRate] {
        if vm.searchText.isEmpty {
            return vm.favouriteCurrencies
        } else {
            return vm.favouriteCurrencies.filter { rate in
                (rate.currency.lowercased().contains(vm.searchText.lowercased()) ||
                 rate.code.lowercased().contains(vm.searchText.lowercased()))
            }
        }
    }
    
    private var currenciesList: some View {
        ForEach(filteredExchangeRates) { rate in
            CurrencyRowView(rate: rate)
                .contextMenu {
                    Button(action: {
                        withAnimation {
                            vm.addToFavourites(rate: rate)
                        }
                    })
                    {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Add to favourite")
                        }
                    }
                }
        }
    }
    
    private func headerText(text: String) -> some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(Color.background)
            .padding(.horizontal)
            .background(Color.gray)
            .cornerRadius(15)
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
    }
}


#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
