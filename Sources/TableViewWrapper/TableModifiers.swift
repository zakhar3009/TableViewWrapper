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
    /// Sets the action to be triggered when a row is selected.
    ///
    /// - Parameter action: A closure that takes the selected item as its parameter.
    /// - Returns: A `TableView` instance with the row selection action configured.
    public func onSelect(_ action: @escaping ElementAction) -> TableView {
        var view = self
        view.selectItemAction = action
        return view
    }

    /// Sets trailing swipe actions for the rows.
    ///
    /// - Important: If a `SwipeAction` has a style of `.destructive`, do not delete the element
    /// within the closure. Instead, provide the action to be executed after the closure completes.
    /// This ensures proper synchronization with the table view's internal data handling.
    ///
    /// - Parameter actions: An array of `SwipeAction` instances to be shown on trailing swipe.
    /// - Returns: A `TableView` instance with the trailing swipe actions configured.
    public func trailingSwipeActions(_ actions: [SwipeAction]) -> TableView {
        var view = self
        view.trailingSwipeActions = actions
        return view
    }

    /// Sets leading swipe actions for the rows.
    ///
    /// - Important: If a `SwipeAction` has a style of `.destructive`, do not delete the element
    /// within the closure. Instead, provide the action to be executed after the closure completes.
    /// This ensures proper synchronization with the table view's internal data handling.
    ///
    /// - Parameter actions: An array of `SwipeAction` instances to be shown on leading swipe.
    /// - Returns: A `TableView` instance with the leading swipe actions configured.
    public func leadingSwipeActions(_ actions: [SwipeAction]) -> TableView {
        var view = self
        view.leadingSwipeActions = actions
        return view
    }
    /// Sets a condition to determine whether a specific row can be moved.
    ///
    /// - Parameter action: A closure that takes an `IndexPath` and returns a `Bool`
    /// indicating whether the row can be moved.
    /// - Returns: A `TableView` instance with the move condition configured.
    public func canMoveRowAt(_ action: @escaping (IndexPath) -> Bool) -> TableView {
        var view = self
        view.canMoveRowAt = action
        return view
    }
    /// Sets the action to be triggered after a row reorder operation is completed.
    ///
    /// - Important: The reordering operation is already applied to the underlying data model
    /// when this action is triggered. You do not need to manually update the data in the closure.
    ///
    /// - Parameter action: A closure to be executed after the row reorder is complete.
    /// - Returns: A `TableView` instance with the reorder action configured.
    public func onReorder(_ action: @escaping () -> Void) -> TableView {
        var view = self
        view.onReorder = action
        return view
    }

    /// Sets the action to be triggered when the table is scrolled.
    ///
    /// - Parameter action: A closure that takes the current vertical offset (`CGFloat`) of the scroll view.
    /// - Returns: A `TableView` instance with the scroll action configured.
    public func didScroll(_ action: @escaping (CGFloat) -> Void) -> TableView {
        var view = self
        view.didScroll = action
        return view
    }

    /// Sets the action to be triggered when scrolling reaches the top of the table.
    ///
    /// - Parameter action: A closure to be executed when the scroll view reaches the top.
    /// - Returns: A `TableView` instance with the scroll-to-top action configured.
    public func didScrollToTop(_ action: @escaping () -> Void) -> TableView {
        var view = self
        view.didScrollToTop = action
        return view
    }

    /// Sets the action to be triggered when dragging begins in the table view.
    ///
    /// - Parameter action: A closure to be executed when the user starts dragging.
    /// - Returns: A `TableView` instance with the begin-dragging action configured.
    public func beginDragging(_ action: @escaping () -> Void) -> TableView {
        var view = self
        view.beginDragging = action
        return view
    }

    /// Sets the action to be triggered when dragging ends in the table view.
    ///
    /// - Parameter action: A closure that takes a `Bool` indicating whether the scroll view
    /// will decelerate after the drag ends.
    /// - Returns: A `TableView` instance with the end-dragging action configured.
    public func endDragging(_ action: @escaping (_ willDecelerate: Bool) -> Void) -> TableView {
        var view = self
        view.endDraging = action
        return view
    }
}
