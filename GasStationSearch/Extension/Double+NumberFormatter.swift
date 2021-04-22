import Foundation

extension Double {

    var currencyValue: String? {
        if let string = currencyFormatter.string(from: NSNumber(value: self)) {
            return string
        }
        return nil
    }
}

let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale.current
    return formatter
}()
