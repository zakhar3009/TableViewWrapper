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
        var oldData: Data?
        var data: Data {
            didSet {
                oldData = oldValue
            }
        }
        
        init(view: TableView, data: Data) {
            self.view = view
            self.data = data
        }
        
        public func numberOfSections(in tableView: UITableView) -> Int {
            data.count
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data[section].count
        }
        
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let action = view.selectItemAction {
                action(data[indexPath.section][indexPath.row])
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
            let data = data[indexPath.section][indexPath.row]
            let content = view.cellContentForData(data)
            cell.configure(with: content)
            return cell
        }
        
        public func deleteRow(at indexPath: IndexPath, in tableView: UITableView) {
            print("Delete row")
            tableView.deleteRows(at: [indexPath], with: .top)
        }
        
        public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            if let leadingSwipeActions = view.leadingSwipeActions {
                let actions = leadingSwipeActions.map { actionConfig in
                    let action = UIContextualAction(style: actionConfig.style, title: actionConfig.title) { (contextualAction, view, completionHandler) in
                        if actionConfig.style == .destructive {
                            actionConfig.handler(indexPath)
                            self.removeItem(at: indexPath)
                            self.deleteRow(at: indexPath, in: tableView)
                        } else {
                            actionConfig.handler(indexPath)
                        }
                        completionHandler(true)
                    }
                    action.image = actionConfig.icon
                    if let color = actionConfig.background {
                        action.backgroundColor = color
                    }
                    return action
                }
                return UISwipeActionsConfiguration(actions: actions)
            }
            return nil
        }
        
        public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            if let trailingSwipeActions = view.trailingSwipeActions {
                let actions = trailingSwipeActions.map { actionConfig in
                    let action = UIContextualAction(style: actionConfig.style, title: actionConfig.title) { (contextualAction, view, completionHandler) in
                        if actionConfig.style == .destructive {
                            actionConfig.handler(indexPath)
                            self.removeItem(at: indexPath)
                            self.deleteRow(at: indexPath, in: tableView)
                        } else {
                            actionConfig.handler(indexPath)
                        }
                        completionHandler(true)
                    }
                    action.image = actionConfig.icon
                    if let color = actionConfig.background {
                        action.backgroundColor = color
                    }
                    return action
                }
                return UISwipeActionsConfiguration(actions: actions)
            }
            return nil
        }
        
        func removeItem(at indexPath: IndexPath) {
            var modifiedData = Array(data)
            var section = Array(modifiedData[indexPath.section])
            section.remove(at: indexPath.row)
            modifiedData[indexPath.section] = Section(section)
            data = Data(modifiedData)
        }
    }
}
