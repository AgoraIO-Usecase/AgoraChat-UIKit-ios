import chat_uikit
import UIKit
import XCTest

final class DataSyncListenerTests: XCTestCase {
    @MainActor
    func testContactSyncCallbacksDispatchThroughOptionalProtocol() {
        let viewModel = ContactSyncViewModel(ignoreIds: [])
        var syncing: [Bool] = []
        viewModel.contactSyncClosure = { syncing.append($0) }
        let listener: ChatDataSyncListener = viewModel

        listener.onChatDataSyncStart?(type: .contacts)
        listener.onChatDataSyncFinished?(error: nil, type: .contacts)

        XCTAssertEqual(syncing, [true, false])
        XCTAssertEqual(viewModel.localReloads, 1)
    }

    @MainActor
    func testConversationSyncCallbacksDispatchThroughOptionalProtocol() {
        let viewModel = ConversationViewModel()
        var syncing: [Bool] = []
        viewModel.conversationSyncClosure = { syncing.append($0) }
        let listener: ChatDataSyncListener = viewModel

        listener.onChatDataSyncStart?(type: .conversations)
        listener.onChatDataSyncFinished?(
            error: ChatError(description: "Offline", code: .networkUnavailable),
            type: .conversations
        )

        XCTAssertEqual(syncing, [true, false])
    }

    @MainActor
    func testJoinedGroupsReloadAfterDatabaseOpenAndSyncCompletion() {
        let controller = JoinedGroupsSyncController()
        let listener: ChatDataSyncListener = controller
        XCTAssertEqual(listener.interestedSyncType, .joinedGroups)

        listener.onChatDatabaseOpened?()
        listener.onChatDataSyncFinished?(error: nil, type: .joinedGroups)
        listener.onChatDataSyncFinished?(
            error: ChatError(description: "Offline", code: .networkUnavailable),
            type: .joinedGroups
        )

        XCTAssertEqual(controller.localReloads, 3)
    }
}

private final class ContactSyncViewModel: ContactViewModel {
    var localReloads = 0

    override func loadAllContacts() {
        localReloads += 1
    }
}

private final class JoinedGroupsSyncController: JoinedGroupsViewController {
    var localReloads = 0

    override func loadLocalGroups() {
        localReloads += 1
    }
}
