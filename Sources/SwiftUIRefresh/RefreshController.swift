//
//  RefreshController.swift
//  SwiftUIRefresh
//
//  Created by ptyuan on 2020/6/27.
//  Copyright © 2020 Vxl. All rights reserved.
//

public class RefreshController {
    public internal(set) var refresh: RefreshType?
    public func beginRefreshing() {
        refresh?.beginRefreshing()
    }

    public func endRefreshing() {
        refresh?.endRefreshing()
    }
    
    public init() {}
}
