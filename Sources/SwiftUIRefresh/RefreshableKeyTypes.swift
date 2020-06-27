//
//  RefreshableKeyTypes.swift
//  SwiftUIRefresh
//
//  Created by ptyuan on 2020/6/27.
//  Copyright © 2020 Vxl. All rights reserved.
//

import SwiftUI

struct RefreshableKeyTypes {
    struct PrefData: Equatable {
        let bounds: CGRect
    }

    struct PrefKey: PreferenceKey {
        static var defaultValue: [PrefData] = []

        static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
            value.append(contentsOf: nextValue())
        }

        typealias Value = [PrefData]
    }
}
