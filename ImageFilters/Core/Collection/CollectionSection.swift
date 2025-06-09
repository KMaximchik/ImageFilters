import UIKit

// MARK: - CollectionSection

struct CollectionSection {
    // MARK: - Internal Properties

    let id: String
    let type: String?
    let headerModel: (any ConfigurableCollectionViewSectionModel)?
    let rowsModels: [CollectionRow]
    let footerModel: (any ConfigurableCollectionViewSectionModel)?

    // MARK: - Init

    init(
        id: String? = nil,
        type: String? = nil,
        header: (any ConfigurableCollectionViewSectionModel)? = nil,
        rows: [CollectionRow],
        footer: (any ConfigurableCollectionViewSectionModel)? = nil
    ) {
        headerModel = header
        rowsModels = rows
        footerModel = footer

        self.type = type
        self.id = id ?? ((headerModel?.id ?? "") + (footerModel?.id ?? ""))
    }

    // MARK: - Internal Methods

    func model(kind: String) -> (any ConfigurableCollectionViewSectionModel)? {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return headerModel

        case UICollectionView.elementKindSectionFooter:
            return footerModel

        default:
            return nil
        }
    }
}

// MARK: - Hashable

extension CollectionSection: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(headerModel?.hashValue)
        hasher.combine(headerModel?.id)
        hasher.combine(footerModel?.hashValue)
        hasher.combine(footerModel?.id)
        hasher.combine(id)
        hasher.combine(type)
    }
}
