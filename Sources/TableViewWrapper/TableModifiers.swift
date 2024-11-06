//
//  File.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 05.11.2024.
//

import Foundation
import UIKit

extension TableView {
    public func onSelect(_ action: @escaping ElementAction) -> TableView {
        var view = self
        view.selectItemAction = action
        return view
    }
    
    public func trailingSwipeActions(_ actions: [SwipeAction]) -> TableView {
        var view = self
        view.trailingSwipeActions = actions
        return view
    }
    
    public func leadingSwipeActions(_ actions: [SwipeAction]) -> TableView {
        var view = self
        view.leadingSwipeActions = actions
        return view
    }
}

