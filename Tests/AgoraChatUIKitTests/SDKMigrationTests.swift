@testable import chat_uikit
import XCTest

final class SDKMigrationTests: XCTestCase {
    func testMissingAppKeyFailsWithoutCreatingServices() {
        let client = ChatUIKitClient()

        XCTAssertEqual(client.setup()?.code, .invalidAppkey)
        XCTAssertEqual(client.setup(appKey: "")?.code, .invalidAppkey)
        XCTAssertNil(client.userService)
        XCTAssertNil(client.contactService)
    }

    func testSyncEventsReachMatchingAndCombinedSubscriptionsOnly() {
        let client = ChatUIKitClient()
        let contacts = SyncRecorder(types: .contacts)
        let combined = SyncRecorder(types: [.contacts, .joinedGroups])
        let conversations = SyncRecorder(types: .conversations)
        [contacts, combined, conversations].forEach { client.addDataSyncListener($0) }
        client.addDataSyncListener(contacts)

        let error = ChatError(description: "Offline", code: .networkUnavailable)
        client.syncDataStart(with: .contacts)
        client.syncDataFinished(error, type: .contacts)

        for recorder in [contacts, combined] {
            XCTAssertEqual(recorder.started, [.contacts])
            XCTAssertEqual(recorder.finished, [.contacts])
            XCTAssertTrue(recorder.lastError === error)
        }
        XCTAssertTrue(conversations.started.isEmpty)
        XCTAssertTrue(conversations.finished.isEmpty)

        client.removeDataSyncListener(contacts)
        client.syncDataStart(with: .contacts)
        XCTAssertEqual(contacts.started.count, 1)
        XCTAssertEqual(combined.started.count, 2)
    }

    func testDatabaseOpenNotifiesAllSubscriptionsOnlyOnSuccess() {
        let client = ChatUIKitClient()
        let recorder = SyncRecorder(types: .joinedGroups)
        client.addDataSyncListener(recorder)
        client.onDatabaseOpened(ChatError(description: "Unavailable", code: .general), username: "user")
        XCTAssertEqual(recorder.databaseOpenCount, 0)

        client.onDatabaseOpened(nil, username: "user")
        XCTAssertEqual(recorder.databaseOpenCount, 1)
    }

    func testReadReceiptsRequireIncomingRequestedAndUnacknowledgedMessages() {
        let message = ReadReceiptMessage(conversationID: "peer", body: ChatTextMessageBody(text: "hello"), ext: nil)
        for incoming in [false, true] {
            for requested in [false, true] {
                for acknowledged in [false, true] {
                    message.direction = incoming ? .receive : .send
                    message.isNeedReadReceipt = requested
                    message.peerRead = acknowledged
                    XCTAssertEqual(
                        ChatServiceImplement.shouldSendReadReceipt(for: message),
                        incoming && requested && !acknowledged
                    )
                }
            }
        }
    }

    func testOlderServerPagesKeepTheOriginalSearchTimeBoundary() {
        let service = ChatServiceImplement(to: "peer")
        let first = service.serverHistoryOption(start: "search-anchor", cursor: nil, anchorTimestamp: 10_000)
        XCTAssertEqual(first.direction, .up)
        XCTAssertEqual(first.endTime, 10_000)

        let next = service.serverHistoryOption(start: "oldest-visible", cursor: "opaque-page-2", anchorTimestamp: 5_000)
        XCTAssertEqual(next.endTime, 10_000)

        let reset = service.serverHistoryOption(start: "", cursor: nil, anchorTimestamp: nil)
        XCTAssertEqual(reset.endTime, -1)

        let newSearch = service.serverHistoryOption(start: "another-anchor", cursor: nil, anchorTimestamp: 20_000)
        XCTAssertEqual(newSearch.endTime, 20_000)
    }

    func testServerBoundaryFilteringPreservesOtherMessagesInTheSameMillisecond() {
        func message(_ id: String) -> ChatMessage {
            let message = ChatMessage(conversationID: "peer", body: ChatTextMessageBody(text: id), ext: nil)
            message.messageId = id
            message.timestamp = 10_000
            return message
        }
        let messages = [message("anchor"), message("same-time-a"), message("same-time-a"), message("same-time-b")]

        XCTAssertEqual(
            ChatServiceImplement.uniqueServerMessages(messages, excluding: "anchor").map(\.messageId),
            ["same-time-a", "same-time-b"]
        )
    }

    func testConversationUpdatesUseTheSeparateSDKDelegate() {
        let service = ConversationServiceImplement()
        let listener: ChatConversationEventsListener = service
        XCTAssertTrue(listener.responds(to: #selector(ChatConversationEventsListener.conversationListDidUpdate(_:))))
    }

    func testGroupDeclineImplementsTheSDKFiveSelector() {
        let service = GroupServiceImplement()
        let listener: GroupEventsListener = service
        XCTAssertTrue(listener.responds(to: #selector(GroupEventsListener.joinGroupRequestDidDecline(_:reason:decliner:applicant:))))
    }
}

private final class ReadReceiptMessage: ChatMessage {
    var peerRead = false
    override var isPeerRead: Bool { peerRead }
}

private final class SyncRecorder: NSObject, ChatDataSyncListener {
    let interestedSyncType: DataSyncType
    var started: [DataSyncType] = []
    var finished: [DataSyncType] = []
    var lastError: ChatError?
    var databaseOpenCount = 0

    init(types: DataSyncType) {
        interestedSyncType = types
    }

    func onChatDatabaseOpened() {
        databaseOpenCount += 1
    }

    func onChatDataSyncStart(type: DataSyncType) {
        started.append(type)
    }

    func onChatDataSyncFinished(error: ChatError?, type: DataSyncType) {
        finished.append(type)
        lastError = error
    }
}
