import MapKit

class GasStationAnnotationView: MKAnnotationView {

    private enum Constants {
        static let width: CGFloat = 82
        static let height: CGFloat = 97
    }

    static let ReuseID = "gasStationAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        centerOffset = CGPoint(x: 0, y: -41)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let annotation = annotation as? GasStationAnnotation {
            image = drawAnnotationImage(annotation.petrolStation.name,
                                  price: annotation.petrolStation.pricePerLiter,
                                  bodyColor: annotation.isCheap ? .orange : .white)

        }
    }

    private func drawAnnotationImage(_ name: String,
                               price: Double,
                               bodyColor: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: Constants.width,
                                                            height: Constants.height))
        return renderer.image { context in
            context.cgContext.setShadow(offset: .zero, blur: 2, color: UIColor.lightGray.cgColor)

            bodyColor.setFill()
            let rect = CGRect(x: 1, y: 1, width: 80, height: 67)

            let mainRect = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: rect.height - 8))

            let leftTopPoint = mainRect.origin
            let rightTopPoint = CGPoint(x: mainRect.maxX, y: mainRect.minY)
            let rightBottomPoint = CGPoint(x: mainRect.maxX, y: mainRect.maxY)
            let leftBottomPoint = CGPoint(x: mainRect.minX, y: mainRect.maxY)

            let leftPoint = CGPoint(x: leftBottomPoint.x + 32, y: leftBottomPoint.y)
            let centerPoint = CGPoint(x: leftPoint.x + 8, y: leftPoint.y + 8 + 5)
            let rightPoint = CGPoint(x: leftPoint.x + 2 * 8, y: leftPoint.y)

            let path = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: rightTopPoint.x - 6, y: rightTopPoint.y + 6), radius: 6,
                        startAngle: CGFloat(3 * Double.pi / 2), endAngle: CGFloat(2 * Double.pi), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rightBottomPoint.x - 6, y: rightBottomPoint.y - 6), radius: 6,
                        startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)

            path.addLine(to: rightPoint)
            path.addLine(to: centerPoint)
            path.addLine(to: leftPoint)
            
            path.addArc(withCenter: CGPoint(x: leftBottomPoint.x + 6, y: leftBottomPoint.y - 6), radius: 6,
                        startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
            path.addArc(withCenter: CGPoint(x: leftTopPoint.x + 6, y: leftTopPoint.y + 6), radius: 6,
                        startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)

            path.fill()
            path.close()

            context.cgContext.setShadow(offset: .zero, blur: 2, color: nil)

            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineBreakMode = .byTruncatingTail

            let attributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "VHV grey3") ?? UIColor.gray,
                              NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12),
                              NSAttributedString.Key.paragraphStyle: style]

            let attributesNameString = NSAttributedString(string: name, attributes: attributes)
            attributesNameString.draw(with: CGRect(x: 5, y: 25, width: 70, height: 15), options: .truncatesLastVisibleLine, context: nil)

            let priceTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "VHV Textcolor") ?? UIColor.black,
                                       NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)]

            let price = String("\(price.currencyValue ?? "0.00")".dropLast())

            let priceSize = price.size(withAttributes: priceTextAttributes)
            let priceRect = CGRect(x: 40 - priceSize.width / 2, y: 28.5, width: priceSize.width, height: 40)
            price.draw(in: priceRect, withAttributes: priceTextAttributes)

            let last = String("\(price)".last ?? "0")

            let attr = [NSAttributedString.Key.foregroundColor: UIColor(named: "VHV Textcolor") ?? UIColor.black,
                                           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]

            let lastDigitSize = last.size(withAttributes: attr)
            let lastDigitRect = CGRect(x: priceRect.origin.x + priceSize.width, y: 31, width: lastDigitSize.width, height: 12)

            last.draw(in: lastDigitRect, withAttributes: attr)

            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: context.currentImage.size.width / 2 - 6, y: 75, width: 12, height: 12)).fill()

            bodyColor.setFill()
            UIBezierPath(ovalIn: CGRect(x: context.currentImage.size.width / 2 - 5, y: 76, width: 10, height: 10)).fill()
        }
    }
}


