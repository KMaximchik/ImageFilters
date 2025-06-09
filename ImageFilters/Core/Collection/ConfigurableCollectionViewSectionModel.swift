import UIKit

// MARK: - ConfigurableCollectionViewSectionModel

protocol ConfigurableCollectionViewSectionModel: Hashable, Sendable {
    var viewSectionType: String { get }

    var id: String { get }
}

extension ConfigurableCollectionViewSectionModel {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func configure(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let itemCell = NSClassFromString(viewSectionType) as? UICollectionViewCell.Type
        else {
            return UICollectionViewCell()
        }

        let cell = collectionView.dequeue(cell: itemCell, for: indexPath)
        if let item = cell as? UnsafeConfigurable {
            item.make(with: self)
        }

        return cell
    }

    func configure(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        kind: String
    ) -> UICollectionReusableView {
        guard
            let itemCell = NSClassFromString(viewSectionType) as? UICollectionReusableView.Type
        else {
            return UICollectionReusableView()
        }

        let cell = collectionView.dequeue(supplementaryView: itemCell, kind: kind, for: indexPath)
        if let item = cell as? UnsafeConfigurable {
            item.make(with: self)
        }

        return cell
    }
}
