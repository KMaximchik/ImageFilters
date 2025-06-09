import UIKit

// MARK: - IFCollectionLayout

enum IFCollectionLayout {
    static func horizontalLayout(
        cellWidth: NSCollectionLayoutDimension = .estimated(1),
        cellHeight: NSCollectionLayoutDimension = .estimated(1),
        needHeader: Bool = false,
        needFooter: Bool = false,
        contentInset: NSDirectionalEdgeInsets = .zero,
        itemEdgeSpacing: NSCollectionLayoutEdgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .none,
            top: .none,
            trailing: .none,
            bottom: .none
        ),
        interGroupSpacing: CGFloat = .zero
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: cellWidth,
            heightDimension: cellHeight
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        item.edgeSpacing = itemEdgeSpacing

        let groupSize = NSCollectionLayoutSize(
            widthDimension: cellWidth,
            heightDimension: cellHeight
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = .zero
        group.edgeSpacing = nil

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInset
        section.interGroupSpacing = interGroupSpacing

        var supplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem]()

        if needHeader {
            supplementaryItems.append(NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize:
                .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            ))
        }

        if needHeader {
            supplementaryItems.append(NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(40)
                ),
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            ))
        }

        section.boundarySupplementaryItems = supplementaryItems
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return section
    }
}
