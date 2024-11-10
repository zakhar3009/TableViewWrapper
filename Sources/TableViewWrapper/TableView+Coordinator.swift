//
//  TableView+Coordinator.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 02.11.2024.
//

import Foundation
import SwiftUI

extension TableView {
    public class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
        let view: TableView
        var oldData: Data?
        @Binding var data: Data {
            didSet {
                self.oldData = oldValue
            }
        }
        
        init(view: TableView, data: Binding<Data>) {
            self.view = view
            self._data = data
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
            let cell = tableView.dequeueReusableCell(withIdentifier: Constans.cellReuseIdentifier,  for: indexPath) as! TableViewCell
            let data = data[indexPath.section][indexPath.row]
            let content = view.cellContentForData(data)
            cell.configure(with: content)
            return cell
        }
        
        public func deleteRow(at indexPath: IndexPath, in tableView: UITableView) {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            if let leadingSwipeActions = view.leadingSwipeActions {
                let actions = leadingSwipeActions.map { actionConfig in
                    return UIContextualAction(actionConfig, indexPath: indexPath) {
                        self.removeDataItem(at: indexPath)
                        self.deleteRow(at: indexPath, in: tableView)
                    }
                }
                return UISwipeActionsConfiguration(actions: actions)
            }
            return nil
        }
        
        public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            if let trailingSwipeActions = view.trailingSwipeActions {
                let actions = trailingSwipeActions.map { actionConfig in
                    return UIContextualAction(actionConfig, indexPath: indexPath) {
                        self.removeDataItem(at: indexPath)
                        self.deleteRow(at: indexPath, in: tableView)
                    }
                }
                return UISwipeActionsConfiguration(actions: actions)
            }
            return nil
        }

        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if let action = view.didScroll {
                action(scrollView.contentOffset.y)
            }
        }
        
        public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
            if let action = view.didScrollToTop {
                action()
            }
        }
        
        public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            if let action = view.beginDragging {
                action()
            }
        }
        
        public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if let action = view.endDraging {
                action(decelerate)
            }
        }
        
        public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .none
        }
        
        public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
        }
        
        public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            moveDataItem(from: sourceIndexPath, at: destinationIndexPath)
            if let onReorder = view.onReorder {
                onReorder()
            }
        }
        
        public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            if let canMoveRowAt = view.canMoveRowAt {
                return canMoveRowAt(indexPath)
            }
            return true
        }
                
        func removeDataItem(at indexPath: IndexPath) {
            var modifiedData = Array(data)
            var section = Array(modifiedData[indexPath.section])
            section.remove(at: indexPath.row)
            modifiedData[indexPath.section] = Section(section)
            data = Data(modifiedData)
        }
        
        func moveDataItem(from source: IndexPath, at destination: IndexPath) {
            var modifiedData = Array(data)
            var sourceSection = Array(modifiedData[source.section])
            let item = sourceSection.remove(at: source.row)
            modifiedData[source.section] = Section(sourceSection)
            var destinationSection = Array(modifiedData[destination.section])
            destinationSection.insert(item, at: destination.row)
            modifiedData[destination.section] = Section(destinationSection)
            data = Data(modifiedData)
        }
    }
}
