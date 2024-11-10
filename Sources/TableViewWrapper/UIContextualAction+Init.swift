//
//  File.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 07.11.2024.
//

import UIKit

extension UIContextualAction {
    convenience init(_ actionConfig: SwipeAction, indexPath: IndexPath, deleteAction: @escaping () -> Void) {
        self.init(style: actionConfig.style, title: actionConfig.title, handler: {
            (contextualAction, view, completionHandler) in
            if actionConfig.style == .destructive {
                print("Delete action")
                actionConfig.handler(indexPath)
                deleteAction()
            } else {
                actionConfig.handler(indexPath)
            }
            completionHandler(true)
        })
        self.image = actionConfig.icon
        if let color = actionConfig.background {
            self.backgroundColor = color
        }
    }
}
