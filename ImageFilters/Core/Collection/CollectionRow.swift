// MARK: - CollectionRow

struct CollectionRow {
    // MARK: - Internal Properties

    var id: String { model.id }
    let model: any ConfigurableCollectionViewCellModel

    // MARK: - Init

    init(model: any ConfigurableCollectionViewCellModel) {
        self.model = model
    }
}

// MARK: - Hashable

extension CollectionRow: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(model.hashValue)
        hasher.combine(model.hashValue)
    }
}
