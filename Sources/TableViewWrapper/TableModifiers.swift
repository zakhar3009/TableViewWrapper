//
//  File.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 05.11.2024.
//

import Foundation
import UIKit

/// A set of modifiers for providing callbacks to various delegate methods of a `UITableView`.
/// These methods allow customization of the table view's behavior by defining actions that are triggered by specific delegate events.
extension TableView {
    
    /// Sets the action for row selection.
    public func onSelect(_ action: @escaping ElementAction) -> TableView {
        var view = self
        view.selectItemAction = action
        return view
    }
    
    /// Sets trailing swipe actions for rows.
    public func trailingSwipeActions(_ actions: [SwipeAction]) -> TableView {
        var view = self
        view.trailingSwipeActions = actions
        return view
    }
    
    /// Sets leading swipe actions for rows.
    public func leadingSwipeActions(_ actions: [SwipeAction]) -> TableView {
        var view = self
        view.leadingSwipeActions = actions
        return view
    }
    
    /// Sets if a row can be moved.
    public func canMoveRowAt(_ action: @escaping (IndexPath) -> Bool) -> TableView {
        var view = self
        view.canMoveRowAt = action
        return view
    }
    
    /// Sets the action triggered after a row reorder.
    public func onReorder(_ action: @escaping () -> Void) -> TableView {
        var view = self
        view.onReorder = action
        return view
    }
    
    /// Sets the action triggered when the table is scrolled.
    public func didScroll(_ action: @escaping (CGFloat) -> ()) -> TableView {
        var view = self
        view.didScroll = action
        return view
    }
    
    /// Sets the action triggered when scrolling reaches the top.
    public func didScrollToTop(_ action: @escaping () -> Void) -> TableView {
        var view = self
        view.didScrollToTop = action
        return view
    }
    
    /// Sets the action triggered when dragging begins.
    public func beginDragging(_ action: @escaping () -> Void) -> TableView {
        var view = self
        view.beginDragging = action
        return view
    }
    
    /// Sets the action triggered when dragging ends.
    public func endDragging(_ action: @escaping (_ willDecelerate: Bool) -> Void) -> TableView {
        var view = self
        view.endDraging = action
        return view
    }
}

