//
//  SwipeActionModel.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 06.11.2024.
//

import SwiftUI

/// A struct representing a swipe action that can be added to a row in a table view.
/// It provides customization options for the action's title, style, icon, background color,
/// row animation on deletion, and a closure handler to handle the action's execution.
///
/// This is typically used with the `UISwipeActionsConfiguration` to add contextual actions to table view rows.
public struct SwipeAction {
    /// The title of the swipe action.
    let title: String
    /// The style of the swipe action (e.g., `.destructive`, `.normal`).
    let style: UIContextualAction.Style
    /// An optional icon for the swipe action.
    let icon: UIImage?
    /// An optional background color for the swipe action button.
    let background: UIColor?
    /// The animation to use when deleting the row (if applicable).
    let deleteAnimation: UITableView.RowAnimation
    /// The closure to be executed when the swipe action is triggered.
    /// It provides the `IndexPath` of the row where the action was triggered.
    let handler: (IndexPath) -> Void
    /// Initializes a new swipe action.
    /// - Parameters:
    ///   - title: The title of the swipe action.
    ///   - style: The style of the swipe action (e.g., `.destructive`, `.normal`).
    ///   - icon: An optional icon for the swipe action.
    ///   - background: An optional background color for the swipe action button.
    ///   - deleteAnimation: The animation to use when deleting the row (default is `.automatic`).
    ///   - handler: The closure to be executed when the action is triggered.
    public init(title: String,
                style: UIContextualAction.Style,
                icon: UIImage? = nil,
                background: UIColor? = nil,
                deleteAnimation: UITableView.RowAnimation = .automatic,
                handler: @escaping (IndexPath) -> Void) {
        self.title = title
        self.style = style
        self.icon = icon
        self.background = background
        self.deleteAnimation = deleteAnimation
        self.handler = handler
    }
}
