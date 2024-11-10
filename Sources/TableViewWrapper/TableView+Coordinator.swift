//
//  TableView+Coordinator.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 02.11.2024.
//

import Foundation
import SwiftUI

extension TableView {
    
    /// The `Coordinator` class is responsible for managing interactions between the `TableView` (a SwiftUI view)
    /// and the underlying `UITableView` (a UIKit component). It conforms to the `UITableViewDataSource`,
    /// `UITableViewDelegate`, and `UIScrollViewDelegate` protocols to handle data and user interactions.
    public class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
        
        // MARK: - Properties
        
        /// The reference to the `TableView` instance
        let view: TableView
        
        /// A property to hold the previous state of the data for comparison.
        var oldData: Data?
        
        /// A binding to the `Data` that populates the table view, allowing it to be updated.
        @Binding var data: Data {
            didSet {
                self.oldData = oldValue // Track changes in the data.
            }
        }
        
        // MARK: - Initializer
                
        /// Initializes the `Coordinator` with the `TableView` instance and the bound `Data`.
        /// - Parameters:
        ///   - view: The `TableView` instance.
        ///   - data: A binding to the data that populates the table view.
        
        init(view: TableView, data: Binding<Data>) {
            self.view = view
            self._data = data
        }
        
        // MARK: - UITableViewDataSource Methods
        
        /// Returns the number of sections in the table view.
        public func numberOfSections(in tableView: UITableView) -> Int {
            data.count
        }
        
        /// Returns the number of rows in a particular section of the table view.
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data[section].count
        }
        
        /// Handles the row selection action when a user taps on a row.
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let action = view.selectItemAction {
                action(data[indexPath.section][indexPath.row])
            }
        }
        
        /// Provides the header view for a section.
        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let sectionHeader = view.sectionHeader(section)
            if !(sectionHeader is EmptyView) {
                let hostingController = UIHostingController(rootView: sectionHeader)
                return hostingController.view
            }
            return nil
        }
        
        /// Returns the height for the section header.
        public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return (view.sectionHeader(section) is EmptyView) ? 0.0 : UITableView.automaticDimension
        }
        
        /// Provides the footer view for a section.
        public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let sectionFooter = view.sectionFooter(section)
            if !(sectionFooter is EmptyView) {
                let hostingController = UIHostingController(rootView: sectionFooter)
                return hostingController.view
            }
            return nil
        }
        
        /// Returns the estimated height for the section footer.
        public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
            return (view.sectionFooter(section) is EmptyView) ? 0.0 : UITableView.automaticDimension
        }
        
        /// Provides the cell for a specific row in the table view.
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constans.cellReuseIdentifier,  for: indexPath) as! TableViewCell
            let data = data[indexPath.section][indexPath.row]
            let content = view.cellContentForData(data)
            cell.configure(with: content)
            return cell
        }
        
        // MARK: - Swipe Actions
        
        /// Handles the deletion of a row.
        public func deleteRow(at indexPath: IndexPath, in tableView: UITableView, with actionConfig: SwipeAction) {
            tableView.deleteRows(at: [indexPath], with: actionConfig.deleteAnimation)
        }
        
        /// Provides leading swipe actions for a row.
        public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            if let leadingSwipeActions = view.leadingSwipeActions {
                let actions = leadingSwipeActions.map { actionConfig in
                    return UIContextualAction(actionConfig, indexPath: indexPath) {
                        self.removeDataItem(at: indexPath)
                        self.deleteRow(at: indexPath, in: tableView, with: actionConfig)
                    }
                }
                return UISwipeActionsConfiguration(actions: actions)
            }
            return nil
        }
        
        /// Provides trailing swipe actions for a row.
        public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            if let trailingSwipeActions = view.trailingSwipeActions {
                let actions = trailingSwipeActions.map { actionConfig in
                    return UIContextualAction(actionConfig, indexPath: indexPath) {
                        self.removeDataItem(at: indexPath)
                        self.deleteRow(at: indexPath, in: tableView, with: actionConfig)
                    }
                }
                return UISwipeActionsConfiguration(actions: actions)
            }
            return nil
        }
        
        /// Sets the editing mode for rows to none in the table view.
        public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .none
        }
        
        /// Disables indentation during editing mode.
        public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
        }
        
        /// Handles the row movement (reordering) action.
        public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            moveDataItem(from: sourceIndexPath, at: destinationIndexPath)
            if let onReorder = view.onReorder {
                onReorder()
            }
        }
        
        /// Checks if a row can be moved.
        public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            if let canMoveRowAt = view.canMoveRowAt {
                return canMoveRowAt(indexPath)
            }
            return true
        }

        
        // MARK: - ScrollView Delegate Methods

        /// Handles scrolling of the table view.
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if let action = view.didScroll {
                action(scrollView.contentOffset.y)
            }
        }
        
        /// Handles when the scroll view has scrolled to the top.
        public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
            if let action = view.didScrollToTop {
                action()
            }
        }
        
        /// Handles the start of dragging in the scroll view.
        public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            if let action = view.beginDragging {
                action()
            }
        }
        
        /// Handles the end of dragging in the scroll view.
        public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if let action = view.endDraging {
                action(decelerate)
            }
        }
        
        // MARK: - Data Modification Methods
        
        /// Removes an item from the data at the specified index path.
        func removeDataItem(at indexPath: IndexPath) {
            var modifiedData = Array(data)
            var section = Array(modifiedData[indexPath.section])
            section.remove(at: indexPath.row)
            modifiedData[indexPath.section] = Section(section)
            data = Data(modifiedData)
        }
        
        /// Moves an item within the data from a source index path to a destination index path.
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
