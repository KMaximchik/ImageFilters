import UIKit

extension UICollectionView {
    func register<T: UICollectionReusableView>(supplementaryClass identifier: T.Type, kind: String) {
        let identifierString = String(describing: identifier)
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifierString)
    }

    func register<T: UICollectionViewCell>(class identifier: T.Type) {
        let identifierString = String(describing: identifier)
        register(T.self, forCellWithReuseIdentifier: identifierString)
    }

    func dequeue<T: UICollectionViewCell>(cell identifier: T.Type, for indexPath: IndexPath) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableCell(withReuseIdentifier: identifierString, for: indexPath) as! T
    }

    func dequeue<T: UICollectionReusableView>(
        supplementaryView identifier: T.Type,
        kind: String,
        for indexPath: IndexPath
    ) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: identifierString,
            for: indexPath
        ) as! T
    }
}
