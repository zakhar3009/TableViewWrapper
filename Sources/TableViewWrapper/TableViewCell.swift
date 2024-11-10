//
//  TableViewCell.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 02.11.2024.
//

import SwiftUI

extension TableView {
    
    /// A custom subclass of `UITableViewCell` used to display content using SwiftUI views inside a table view.
    /// This class uses a `UIHostingController` to embed a SwiftUI `CellContent` view within a standard UIKit table view cell.
    /// It allows SwiftUI views to be used seamlessly within a `UITableView` by configuring the cell's content.
    public class TableViewCell: UITableViewCell {
        
        /// The hosting controller used to embed the SwiftUI content inside the cell.
        private var hostingController: UIHostingController<CellContent>?
        
        /// Configures the cell with the provided SwiftUI view content.
        /// - Parameter content: The SwiftUI view to be displayed inside the cell.
        /// - This method ensures that the SwiftUI view is embedded in the cell and updates the view if the content changes.
        func configure(with content: CellContent) {
            self.selectionStyle = .none
            
            // If the hosting controller doesn't exist, create a new one and add the SwiftUI view to the cell.
            if hostingController == nil {
                hostingController = UIHostingController(rootView: content)
                guard let host = hostingController else { return }
                host.view.translatesAutoresizingMaskIntoConstraints = false
                // Add the SwiftUI view to the content view and constrain it to fill the cell.
                contentView.addSubview(host.view)
                NSLayoutConstraint.activate([
                    host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                    host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
            } else {
                // If the hosting controller already exists, update the root view to the new content.
                hostingController?.rootView = content
            }
        }
    }
    
    /// A struct containing constant values used by `TableView`.
    /// The constants include reuse identifiers and other static values for table view cells.
    enum Constans {
        
        /// The reuse identifier used for the custom table view cell.
        /// This value should be used to dequeue reusable table view cells of type `TableViewCell`.
        static var cellReuseIdentifier: String {
            "CustomTableViewCell"
        }
    }
}
