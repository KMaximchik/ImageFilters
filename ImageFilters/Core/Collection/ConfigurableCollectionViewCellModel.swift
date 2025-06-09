import UIKit

// MARK: - ConfigurableCollectionViewCellModel

protocol ConfigurableCollectionViewCellModel: Hashable {
    var viewCellType: String { get }

    var id: String { get }
}

extension ConfigurableCollectionViewCellModel {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func configure(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemCell = NSClassFromString(viewCellType) as? UICollectionViewCell.Type else {
            return UICollectionViewCell()
        }

        let cell = collectionView.dequeue(cell: itemCell, for: indexPath)

        if let item = cell as? UnsafeConfigurable {
            item.make(with: self)
        }

        return cell
    }
}
