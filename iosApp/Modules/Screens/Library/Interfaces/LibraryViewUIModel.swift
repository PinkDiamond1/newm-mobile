import Foundation
import shared
import SharedUI
import ModuleLinker

struct LibraryViewUIModel {
    let title: TitleSectionModel
    let recentlyPlayedSection: CellsSectionModel<BigCellViewModel>
    let yourPlaylistsSection: CellsSectionModel<BigCellViewModel>
    let likedSongsSection: CellsSectionModel<BigCellViewModel>
}

protocol LibraryViewUIModelProviding {
    func getModel() async throws -> LibraryViewUIModel
}