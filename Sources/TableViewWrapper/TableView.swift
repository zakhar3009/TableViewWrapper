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
where Data: RandomAccessCollection,
      Data.Element: RandomAccessCollection,
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
    
    public let data: Data
    public let cellContentForData: (RowData) -> CellContent
    public let header: TableHeaderContent?
    public let footer: TableFooterContent?
    public let sectionHeader: (Int) -> SectionHeaderContent
    public let sectionFooter: (Int) -> SectionFooterContent
    public var selectItemAction: ElementAction? = nil
    
    
    public func makeUIViewController(context: Context) -> UITableViewController {
        let controller = UITableViewController()
        controller.tableView.register(TableViewCell.self, forCellReuseIdentifier: Constans.cellReuseIdentifier)
        controller.tableView.dataSource = context.coordinator
        controller.tableView.delegate = context.coordinator
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
        uiViewController.tableView.reloadData()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(view: self)
    }
    
    public init(data: Data,
                @ViewBuilder cellContentForData: @escaping (RowData) -> CellContent,
                @ViewBuilder header: @escaping () -> TableHeaderContent = { EmptyView() },
                @ViewBuilder footer: @escaping () -> TableFooterContent = { EmptyView() },
                @ViewBuilder sectionHeader: @escaping (Int) -> SectionHeaderContent = { _ in EmptyView() },
                @ViewBuilder sectionFooter: @escaping (Int) -> SectionFooterContent = { _ in EmptyView() }
    ) {
        self.data = data
        self.cellContentForData = cellContentForData
        self.header = (header() is EmptyView) ? nil : header()
        self.footer = (footer() is EmptyView) ? nil : footer()
        self.sectionHeader = sectionHeader
        self.sectionFooter = sectionFooter
    }
}


