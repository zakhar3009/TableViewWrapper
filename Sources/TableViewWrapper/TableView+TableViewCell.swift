//
//  File.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 02.11.2024.
//

import SwiftUI

extension TableView {
    public class TableViewCell: UITableViewCell {
        private var hostingController: UIHostingController<CellContent>?
        
        func configure(with content: CellContent) {
            self.selectionStyle = .none
            if hostingController == nil {
                hostingController = UIHostingController(rootView: content)
                guard let host = hostingController else { return }
                host.view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(host.view)
                NSLayoutConstraint.activate([
                    host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                    host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
            } else {
                hostingController?.rootView = content
            }
        }
    }
    
    enum Constans {
        static var cellReuseIdentifier: String {
            "CustomTableViewCell"
        }
    }
}
