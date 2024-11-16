//
//  TableView.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 02.11.2024.
//

import SwiftUI
/// A custom `TableView` wrapper that integrates SwiftUI views into a UIKit `UITableView`.
/// This struct provides a SwiftUI-friendly interface for managing UITableView behaviors like selection, swipe actions, reordering, and more.
///
/// - Parameters:
///   - Data: A collection of sections, where each section contains a collection of rows.
///   - CellContent: The content view displayed for each row.
///   - TableHeaderContent: The content view displayed in the table header.
///   - TableFooterContent: The content view displayed in the table footer.
///   - SectionHeaderContent: The content view displayed for each section header.
///   - SectionFooterContent: The content view displayed for each section footer.
///
/// - Note:
///   This component uses UIKit's `UITableViewController` for underlying table management and allows integrating SwiftUI components within it.
///
/// Example usage:
/// ```
/// TableView(
///     data: $data,
///     cellContentForData: { item in
///         Text(item.name)
///     },
///     header: { Text("Table Header") },
///     footer: { Text("Table Footer") }
/// )
/// ```

public struct TableView<Data,
                        CellContent,
                        TableHeaderContent,
                        TableFooterContent,
                        SectionHeaderContent,
                        SectionFooterContent>: UIViewControllerRepresentable
where Data: RandomAccessCollection & RangeReplaceableCollection,
      Data.Element: RandomAccessCollection & RangeReplaceableCollection,
      Data.Index == Int,
      Data.Element.Index == Int,
      CellContent: View,
      TableHeaderContent: View,
      TableFooterContent: View,
      SectionHeaderContent: View,
      SectionFooterContent: View {
    // MARK: CollectionView typealiases
    public typealias UIViewControllerType = UITableViewController
    public typealias Section = Data.Element
    public typealias RowData = Section.Element
    public typealias ElementAction = (Data.Element.Element) -> Void
    /// A binding to the data source of the table view.
    @Binding var data: Data
    /// A binding to control whether the table view is in editing mode.
    public var isEditing: Binding<Bool>?
    /// A closure that generates the content view for each cell based on row data.
    public let cellContentForData: (RowData) -> CellContent
    /// A boolean that controls whether scrolling is enabled.
    public let scrollEnabled: Bool
    /// A boolean that controls whether the table view bounces at the edges.
    public let bounces: Bool
    /// The rate at which the table view decelerates when scrolling.
    public let decelerationRate: UIScrollView.DecelerationRate
    /// The separator style for the table view cells.
    public let seperatorStyle: UITableViewCell.SeparatorStyle
    /// The content view displayed in the table header.
    public let header: TableHeaderContent?
    /// The content view displayed in the table footer.
    public let footer: TableFooterContent?
    /// A closure that generates the content for each section header.
    public let sectionHeader: (Int) -> SectionHeaderContent?
    /// A closure that generates the content for each section footer.
    public let sectionFooter: (Int) -> SectionFooterContent?
    /// An optional action triggered when a table item is selected.
    public var selectItemAction: ElementAction?
    /// An array of swipe actions to be displayed when swiping right.
    public var trailingSwipeActions: [SwipeAction]?
    /// An array of swipe actions to be displayed when swiping left.
    public var leadingSwipeActions: [SwipeAction]?
    /// A closure that determines if a row can be moved (reordered).
    public var canMoveRowAt: ((IndexPath) -> Bool)?
    /// A closure to handle reordering actions.
    public var onReorder: (() -> Void)?
    /// A closure that is called when the table view is scrolled.
    public var didScroll: ((_ offset: CGFloat) -> Void)?
    /// A closure that is called when the table view reaches the top.
    public var didScrollToTop: (() -> Void)?
    /// A closure that is called when the table view starts dragging.
    public var beginDragging: (() -> Void)?
    /// A closure that is called when the table view ends dragging.
    public var endDraging: ((_ willDecelerate: Bool) -> Void)?
    // MARK: - TableView Lifecycle
    /// Creates and configures the underlying UITableViewController.
    public func makeUIViewController(context: Context) -> UITableViewController {
        let controller = UITableViewController()
        controller.tableView.register(TableViewCell.self, forCellReuseIdentifier: Constans.cellReuseIdentifier)
        controller.tableView.dataSource = context.coordinator
        controller.tableView.delegate = context.coordinator
        controller.tableView.bounces = bounces
        controller.tableView.decelerationRate = decelerationRate
        controller.tableView.isScrollEnabled = scrollEnabled
        controller.tableView.separatorStyle = seperatorStyle
        controller.tableView.dragInteractionEnabled = true
        setupHeader(for: controller)
        setupFooter(for: controller)
        return controller
    }
    /// Configures the header for the table view.
    private func setupHeader(for tableViewController: UITableViewController) {
        if let headerView = header {
            let hostingController = UIHostingController(rootView: headerView)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            let headerContainerView = UIView()
            headerContainerView.addSubview(hostingController.view)
            tableViewController.tableView.tableHeaderView = headerContainerView
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor)
            ])
            headerContainerView.frame.size.height = hostingController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            hostingController.didMove(toParent: tableViewController)
        }
    }
    /// Configures the footer for the table view.
    private func setupFooter(for tableViewController: UITableViewController) {
        if let footerView = footer {
            let hostingController = UIHostingController(rootView: footerView)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            let footerContainerView = UIView()
            footerContainerView.addSubview(hostingController.view)
            tableViewController.tableView.tableFooterView = footerContainerView
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: footerContainerView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: footerContainerView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: footerContainerView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: footerContainerView.bottomAnchor)
            ])
            footerContainerView.frame.size.height = hostingController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            hostingController.didMove(toParent: tableViewController)
        }
    }

    /// Updates the `UITableViewController` when the data changes.
    public func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        if let isEditing {
            uiViewController.tableView.setEditing(isEditing.wrappedValue, animated: true)
        }
        if !context.coordinator.rowDeleted {
            DispatchQueue.main.async {
                uiViewController.tableView.reloadData()
            }
        } else {
            context.coordinator.rowDeleted = false
        }
    }
    /// Creates the coordinator to manage the data binding and interactions.
    public func makeCoordinator() -> Coordinator {
        Coordinator(view: self, data: $data)
    }
    // MARK: - Initializer
    /// Initializes the `TableView` with the provided parameters.
    public init(data: Binding<Data>,
                @ViewBuilder cellContentForData: @escaping (RowData) -> CellContent,
                isEditing: Binding<Bool>? = nil,
                bounces: Bool = true,
                decelerationRate: UIScrollView.DecelerationRate = .normal,
                seperatorStyle: UITableViewCell.SeparatorStyle = .singleLine,
                scrollEnabled: Bool = true,
                @ViewBuilder header: @escaping () -> TableHeaderContent = { EmptyView() },
                @ViewBuilder footer: @escaping () -> TableFooterContent = { EmptyView() },
                @ViewBuilder sectionHeader: @escaping (Int) -> SectionHeaderContent = { _ in EmptyView() },
                @ViewBuilder sectionFooter: @escaping (Int) -> SectionFooterContent = { _ in EmptyView() }
    ) {
        self._data = data
        self.cellContentForData = cellContentForData
        self.isEditing = isEditing
        self.bounces = bounces
        self.decelerationRate = decelerationRate
        self.scrollEnabled = scrollEnabled
        self.seperatorStyle = seperatorStyle
        self.header = (header() is EmptyView) ? nil : header()
        self.footer = (footer() is EmptyView) ? nil : footer()
        self.sectionHeader = sectionHeader
        self.sectionFooter = sectionFooter
    }
}
