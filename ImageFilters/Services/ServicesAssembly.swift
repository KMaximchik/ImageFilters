// MARK: - ServicesAssemblyInterface

protocol ServicesAssemblyInterface {
    var permissionsService: PermissionsServiceInterface { get }
    var filtersService: FiltersServiceInterface { get }
}

// MARK: - ServicesAssemly

final class ServicesAssembly: ServicesAssemblyInterface {
    // MARK: - Internal Properties

    lazy var permissionsService: PermissionsServiceInterface = PermissionsService()
    lazy var filtersService: FiltersServiceInterface = FiltersService()
}
