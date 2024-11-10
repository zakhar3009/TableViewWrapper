//
//  File.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 07.11.2024.
//

import UIKit

extension UIContextualAction {
    
    /// A convenience initializer for creating a `UIContextualAction` using a `SwipeAction` configuration.
    ///
    /// This initializer simplifies the creation of contextual actions used in swipe gestures within table views.
    /// It allows you to configure the action's style, title, icon, background color, and associated handler to perform custom actions.
    ///
    /// - Parameters:
    ///   - actionConfig: The `SwipeAction` configuration that defines the action's properties, such as the style, title, icon, and handler.
    ///   - indexPath: The `IndexPath` of the row in the table view where the swipe action is applied.
    ///   - deleteAction: A closure to be executed if the swipe action's style is `.destructive`, indicating a delete operation.
    ///
    /// This initializer also handles triggering the associated handler of the `SwipeAction` and completing the action.
    convenience init(_ actionConfig: SwipeAction, indexPath: IndexPath, deleteAction: @escaping () -> Void) {
        
        // Initialize the contextual action with the style, title, and handler.
        self.init(style: actionConfig.style, title: actionConfig.title, handler: {
            (contextualAction, view, completionHandler) in
            
            // If the action's style is destructive, execute the delete logic and the custom handler.
            if actionConfig.style == .destructive {
                actionConfig.handler(indexPath)
                deleteAction()
            } else {
                // For non-destructive actions, just execute the handler.
                actionConfig.handler(indexPath)
            }
            
            // Complete the action.
            completionHandler(true)
        })
        
        // Set the icon for the action if provided.
        self.image = actionConfig.icon
        
        // Set the background color for the action if provided.
        if let color = actionConfig.background {
            self.backgroundColor = color
        }
    }
}
