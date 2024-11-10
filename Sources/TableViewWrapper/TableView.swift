//
//  TableView.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 02.11.2024.
//

import SwiftUI

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
    
    public typealias UIViewControllerType = UITableViewController
    public typealias Section = Data.Element
    public typealias RowData = Section.Element
    public typealias ElementAction = (Data.Element.Element) -> Void
    
    @Binding var data: Data
    public var isEditing: Binding<Bool>?
    public let cellContentForData: (RowData) -> CellContent
    public let scrollEnabled: Bool
    public let bounces: Bool
    public let decelerationRate: UIScrollView.DecelerationRate
    public let seperatorStyle: UITableViewCell.SeparatorStyle
    public let header: TableHeaderContent?
    public let footer: TableFooterContent?
    public let sectionHeader: (Int) -> SectionHeaderContent?
    public let sectionFooter: (Int) -> SectionFooterContent?
    public var selectItemAction: ElementAction?
    public var trailingSwipeActions: [SwipeAction]?
    public var leadingSwipeActions: [SwipeAction]?
    public var canMoveRowAt: ((IndexPath) -> Bool)?
    public var onReorder: (() -> Void)?
    public var didScroll: ((_ offset: CGFloat) -> ())?
    public var didScrollToTop: (() -> Void)?
    public var beginDragging: (() -> Void)?
    public var endDraging: ((_ willDecelerate: Bool) -> Void)?
    
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

    public func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        if let isEditing {
            uiViewController.tableView.setEditing(isEditing.wrappedValue, animated: true)
        }
        if let oldCount = context.coordinator.oldData?.flatMap({ $0 }).count {
            if oldCount <= data.flatMap({ $0 }).count {
                DispatchQueue.main.async {
                    uiViewController.tableView.reloadData()
                }
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(view: self, data: $data)
    }
    
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


