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
    
    public func canMoveRowAt(_ action: @escaping (IndexPath) -> Bool) -> TableView {
        var view = self
        view.canMoveRowAt = action
        return view
    }
    
    public func onReorder(_ action: @escaping () -> Void) -> TableView {
        var view = self
        view.onReorder = action
        return view
    }
    
    public func didScroll(_ action: @escaping (CGFloat) -> ()) -> TableView {
        var view = self
        view.didScroll = action
        return view
    }
    
    public func didScrollToTop(_ action: @escaping () -> Void) -> TableView {
        var view = self
        view.didScrollToTop = action
        return view
    }
    
    public func beginDragging(_ action: @escaping () -> Void) -> TableView {
        var view = self
        view.beginDragging = action
        return view
    }
    
    public func endDragging(_ action: @escaping (_ willDecelerate: Bool) -> Void) -> TableView {
        var view = self
        view.endDraging = action
        return view
    }
}

