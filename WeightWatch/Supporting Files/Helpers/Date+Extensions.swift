import Foundation

private let dateDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    dateFormatter.timeZone = TimeZone(identifier: "GMT")
    dateFormatter.dateFormat = "dd.MM.YY"
    return dateFormatter
}()

extension Date {
    var dateString: String { dateDefaultFormatter.string(from: self) }
}
