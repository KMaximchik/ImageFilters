import Foundation
import UIKit
import Combine

// MARK: - HomeViewModelInterface

protocol HomeViewModelInterface: AnyObject {
    var imageSavingPublisher: PassthroughSubject<Bool, Never> { get }
    var collectionSectionsPublisher: AnyPublisher<[CollectionSection], Never> { get }
    var filteredImagePublisher: AnyPublisher<UIImage?, Never> { get }
    var selectedFilterPublisher: AnyPublisher<FilterType, Never> { get }

    func didTapSelectButton()
    func didTapPlusButton()
    func didTapSaveButton()
    func didChangeSliderValue(_ value: Float)
}

// MARK: - HomeViewModel

final class HomeViewModel {
    // MARK: - Nested Types

    enum SectionType: String {
        case filters
    }

    // MARK: - Internal Properties

    var imageSavingPublisher = PassthroughSubject<Bool, Never>()

    var filteredImagePublisher: AnyPublisher<UIImage?, Never> {
        $filteredImage.eraseToAnyPublisher()
    }

    var collectionSectionsPublisher: AnyPublisher<[CollectionSection], Never> {
        $collectionSections.eraseToAnyPublisher()
    }

    var selectedFilterPublisher: AnyPublisher<FilterType, Never> {
        $selectedFilterType.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    @Published private var selectedImage: UIImage?
    @Published private var filteredImage: UIImage?
    @Published private var collectionSections = [CollectionSection]()
    @Published private var selectedFilterType = FilterType.original
    @Published private var intensity: Float = 1

    private var filtersImages = [String: UIImage]()
    private var selectedCiImage: CIImage?
    private var cancellables = Set<AnyCancellable>()

    private let permissionsService: PermissionsServiceInterface
    private let filtersService: FiltersServiceInterface

    private weak var output: HomeOutputInterface?

    // MARK: - Init

    init(
        permissionsService: PermissionsServiceInterface,
        filtersService: FiltersServiceInterface,
        output: HomeOutputInterface?
    ) {
        self.permissionsService = permissionsService
        self.filtersService = filtersService
        self.output = output

        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        $selectedImage
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .sink { [weak self] selectedImage in
                guard let self, let selectedImage else { return }

                self.selectedCiImage = CIImage(image: selectedImage)

                guard let selectedCiImage else { return }

                FilterType.allCases.forEach {
                    self.filtersImages[$0.rawValue] = self.filtersService.applyFilter(
                        $0,
                        to: selectedCiImage,
                        with: 1,
                        scale: selectedImage.scale,
                        orientation: selectedImage.imageOrientation
                    )
                }
                self.collectionSections = self.getCollectionSections(
                    for: selectedImage,
                    with: self.selectedFilterType
                )
                self.filteredImage = self.filtersService.applyFilter(
                    self.selectedFilterType,
                    to: selectedCiImage,
                    with: self.intensity,
                    scale: selectedImage.scale,
                    orientation: selectedImage.imageOrientation
                )
            }
            .store(in: &cancellables)

        $selectedFilterType
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .sink { [weak self] selectedFilter in
                guard let self, let selectedImage, let selectedCiImage else { return }

                self.collectionSections = self.getCollectionSections(
                    for: selectedImage,
                    with: selectedFilter
                )
                self.filteredImage = self.filtersService.applyFilter(
                    selectedFilter,
                    to: selectedCiImage,
                    with: self.intensity,
                    scale: selectedImage.scale,
                    orientation: selectedImage.imageOrientation
                )
            }
            .store(in: &cancellables)

        $intensity
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .sink { [weak self] intensity in
                guard let self, let selectedImage, let selectedCiImage else { return }

                self.collectionSections = self.getCollectionSections(
                    for: selectedImage,
                    with: self.selectedFilterType
                )
                self.filteredImage = self.filtersService.applyFilter(
                    self.selectedFilterType,
                    to: selectedCiImage,
                    with: intensity,
                    scale: selectedImage.scale,
                    orientation: selectedImage.imageOrientation
                )
            }
            .store(in: &cancellables)
    }

    private func getCollectionSections(for image: UIImage, with selectedFilter: FilterType) -> [CollectionSection] {
        [
            CollectionSection(
                id: SectionType.filters.rawValue,
                type: SectionType.filters.rawValue,
                rows: FilterType.allCases.map {
                    CollectionRow(
                        model: HomeFilterCollectionViewCellModel(
                            id: $0.rawValue,
                            image: filtersImages[$0.rawValue],
                            filterType: $0,
                            isSelected: $0 == selectedFilterType,
                            onSelect: { [weak self] filterType in
                                self?.selectedFilterType = filterType
                            }
                        )
                    )
                }
            )
        ]
    }

    private func openPickerIfCan() {
        permissionsService.request(.gallery) { [weak self] status in
            guard !status.granted else {
                self?.output?.homeShowImagePicker()

                return
            }

            self?.output?.homeShowAlert(
                title: "Home.alert.permission.title".localized(),
                message: "Home.alert.permission.message".localized(),
                actions: [
                    UIAlertAction(
                        title: "Common.cancel.title".localized(),
                        style: .cancel,
                        handler: nil
                    ),
                    UIAlertAction(
                        title: "Home.alert.permission.button.settings.title".localized(),
                        style: .default,
                        handler: { [weak self] _ in
                            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                self?.output?.homeOpenUrl(settingsUrl)
                            }
                        }
                    )
                ],
                style: .alert
            )
        }
    }

    private func saveFilteredImage() {
        permissionsService.request(.gallery) { [weak self] status in
            guard let self, let filteredImage, status.granted else {
                self?.imageSavingPublisher.send(false)

                return
            }

            DispatchQueue.global(qos: .userInteractive).async {
                UIImageWriteToSavedPhotosAlbum(filteredImage, nil, nil, nil)
            }

            self.imageSavingPublisher.send(true)
        }
    }
}

// MARK: - HomeInputInterface

extension HomeViewModel: HomeInputInterface {
    func setSelectedImage(_ image: UIImage) {
        selectedImage = image
    }
}

// MARK: - HomeViewModelInterface

extension HomeViewModel: HomeViewModelInterface {
    func didTapSelectButton() {
        openPickerIfCan()
    }

    func didTapPlusButton() {
        openPickerIfCan()
    }

    func didChangeSliderValue(_ value: Float) {
        intensity = value
    }

    func didTapSaveButton() {
        saveFilteredImage()
    }
}
