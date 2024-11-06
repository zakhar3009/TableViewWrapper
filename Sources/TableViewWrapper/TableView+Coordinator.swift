//
//  TableView+Coordinator.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 02.11.2024.
//

import Foundation
import SwiftUI

extension TableView {
    public class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        let view: TableView
        
        init(view: TableView) {
            self.view = view
        }
        
        public func numberOfSections(in tableView: UITableView) -> Int {
            view.data.count
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return view.data[section].count
        }
        
        
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let action = view.selectItemAction {
                action(view.data[indexPath.section][indexPath.row])
            }
        }
        
        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let sectionHeader = view.sectionHeader(section)
            if !(sectionHeader is EmptyView) {
                let hostingController = UIHostingController(rootView: sectionHeader)
                return hostingController.view
            }
            return nil
        }
        
        public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return (view.sectionHeader(section) is EmptyView) ? 0.0 : UITableView.automaticDimension
        }
        
        public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let sectionFooter = view.sectionFooter(section)
            if !(sectionFooter is EmptyView) {
                let hostingController = UIHostingController(rootView: sectionFooter)
                return hostingController.view
            }
            return nil
        }
        
        public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
            return (view.sectionFooter(section) is EmptyView) ? 0.0 : UITableView.automaticDimension
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constans.cellReuseIdentifier,
                                                     for: indexPath) as! TableViewCell
            let data = view.data[indexPath.section][indexPath.row]
            let content = view.cellContentForData(data)
            cell.configure(with: content)
            return cell
        }
        
    }
}
