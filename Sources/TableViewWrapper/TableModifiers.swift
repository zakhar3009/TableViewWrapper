//
//  File.swift
//  TableViewWrapper
//
//  Created by Zakhar Litvinchuk on 05.11.2024.
//

import Foundation

extension TableView {
    public func onSelect(_ action: @escaping (Data.Element.Element) -> Void) -> TableView {
        var view = self
        view.selectItemAction = action
        return view
    }
}
