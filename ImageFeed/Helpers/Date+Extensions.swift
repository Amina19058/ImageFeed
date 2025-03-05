//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 02.03.2025.
//

import Foundation

extension Date {
    var dateString: String { DateFormatter.dateFormatter.string(from: self) }
}

private extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
