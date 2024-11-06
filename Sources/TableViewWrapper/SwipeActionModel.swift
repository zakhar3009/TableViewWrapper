//
//  File.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 06.11.2024.
//

import SwiftUI

public struct SwipeAction {
    let title: String
    let style: UIContextualAction.Style
    let icon: UIImage?
    let background: UIColor?
    let deleteAnimation: UITableView.RowAnimation
    let handler: (IndexPath) -> Void
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
