//
//  ContentView.swift
//  Examples
//
//  Created by ptyuan on 2020/6/27.
//  Copyright © 2020 Vxl. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh

struct ContentView: View {
    @State var numbers:[Int] = Array(0..<10)
    let refreshController: RefreshController = RefreshController()
    var body: some View {
        RefreshNavigationView(title: "SwiftUIRefresh", refreshController: refreshController, action:{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.numbers = self.refreshNumbers()
                self.refreshController.endRefreshing()
            }
        }){
            ForEach(self.numbers, id: \.self){ number in
                VStack(alignment: .leading){
                    Text("\(number)")
                    Divider()
                }
            }
        }
        .onAppear {
            /* beginRefreshing
            self.refreshController.beginRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.numbers = self.refreshNumbers()
                self.refreshController.endRefreshing()
            }
            */
        }
    }
    
    func refreshNumbers() -> [Int] {
        var numbers = [Int]()
        for _ in 0...30 {
            numbers.append(Int.random(in: 0 ..< 1000))
        }
        return numbers
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
