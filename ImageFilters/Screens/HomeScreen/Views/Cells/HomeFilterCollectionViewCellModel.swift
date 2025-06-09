import UIKit

// MARK: - HomeFilterCollectionViewCellModel

struct HomeFilterCollectionViewCellModel: ConfigurableCollectionViewCellModel {
    var viewCellType: String {
        NSStringFromClass(HomeFilterCollectionViewCell.self)
    }

    let id: String
    let image: UIImage?
    let filterType: FilterType
    let isSelected: Bool
    let onSelect: (FilterType) -> Void

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(image)
        hasher.combine(filterType)
        hasher.combine(isSelected)
    }
}
