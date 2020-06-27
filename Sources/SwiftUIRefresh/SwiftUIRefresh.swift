//
//  Refresh.swift
//  SwiftUIRefresh
//
//  Created by ptyuan on 2020/6/27.
//  Copyright © 2020 Vxl. All rights reserved.
//

import SwiftUI

public struct RefreshNavigationView<Content: View>: View {
    let content: () -> Content
    let action: () -> Void
    @State public var showRefreshView: Bool = false
    @State public var pullStatus: CGFloat = 0
    private var title: String
    let refreshController: RefreshController

    public init(title: String, refreshController: RefreshController, action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.action = action
        self.content = content
        self.refreshController = refreshController
    }

    public var body: some View {
        NavigationView {
            RefreshList(showRefreshView: $showRefreshView, pullStatus: $pullStatus, action: self.action, refreshController: refreshController) {
                self.content()
            }.navigationBarTitle(title)
        }
        .offset(x: 0, y: self.showRefreshView ? 34 : 0)
        .onAppear {
            UITableView.appearance().separatorColor = .clear
        }
    }
}

public struct RefreshList<Content: View>: View, RefreshType {
    @Binding var showRefreshView: Bool
    @Binding var pullStatus: CGFloat
    let action: () -> Void
    let content: () -> Content
    let refreshController: RefreshController

    init(showRefreshView: Binding<Bool>, pullStatus: Binding<CGFloat>, action: @escaping () -> Void, refreshController: RefreshController, @ViewBuilder content: @escaping () -> Content) {
        _showRefreshView = showRefreshView
        _pullStatus = pullStatus
        self.action = action
        self.content = content
        self.refreshController = refreshController
        self.refreshController.refresh = self
    }

    public var body: some View {
        List {
            RefreshHeaderView(showRefreshView: $showRefreshView, pullStatus: $pullStatus)
            content()
        }
        .onPreferenceChange(RefreshableKeyTypes.PrefKey.self) { values in
            guard let bounds = values.first?.bounds else { return }
            self.pullStatus = CGFloat((bounds.origin.y - 106) / 80)
            self.refresh(offset: bounds.origin.y)
        }.offset(x: 0, y: -40)
    }

    func refresh(offset: CGFloat) {
        if offset > 185, showRefreshView == false {
            beginRefreshing()
            action()
        }
    }

    public func beginRefreshing() {
        DispatchQueue.main.async {
            self.showRefreshView = true
        }
    }

    public func endRefreshing() {
        showRefreshView = false
    }
}

struct Spinner: View {
    @Binding var percentage: CGFloat
    var body: some View {
        GeometryReader { _ in
            ForEach(1 ... 10, id: \.self) { i in
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(1)
                    .frame(width: 2.5, height: 8)
                    .opacity(self.percentage * 10 >= CGFloat(i) ? Double(i) / 10.0 : 0)
                    .offset(x: 0, y: -8)
                    .rotationEffect(.degrees(Double(36 * i)), anchor: .bottom)
            }.offset(x: 20, y: 12)
        }.frame(width: 40, height: 40)
    }
}

struct RefreshView: View {
    @Binding var isRefreshing: Bool
    @Binding var status: CGFloat
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                if !isRefreshing {
                    Spinner(percentage: $status)
                } else {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
            }
            Spacer()
        }
    }
}

struct RefreshHeaderView: View {
    @Binding var showRefreshView: Bool
    @Binding var pullStatus: CGFloat
    var body: some View {
        GeometryReader { geometry in
            RefreshView(isRefreshing: self.$showRefreshView, status: self.$pullStatus)
                .opacity(Double((geometry.frame(in: CoordinateSpace.global).origin.y - 106) / 80)).preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(bounds: geometry.frame(in: CoordinateSpace.global))])
                .offset(x: 0, y: -90)
        }
    }
}
