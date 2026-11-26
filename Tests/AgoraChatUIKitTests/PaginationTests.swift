@testable import chat_uikit
import XCTest

final class PaginationTests: XCTestCase {
    @MainActor
    func testBackwardPagesAfterSearchKeepOrderAndSkipOverlappingMessages() {
        let previous = ChatUIKitClient.shared.option.option_UI.loadLocalHistoryMessages
        ChatUIKitClient.shared.option.option_UI.loadLocalHistoryMessages = false
        defer { ChatUIKitClient.shared.option.option_UI.loadLocalHistoryMessages = previous }
        let service = PaginationService()
        let driver = PaginationDriver()
        driver.messages = [message("anchor"), message("newer")]
        let model = MessageListViewModel(conversationId: "peer", type: .chat, historyService: service)
        model.bindDriver(driver: driver)
        model.loadMessages()
        XCTAssertEqual(service.requests.count, 1, "Only one page may be in flight")
        XCTAssertEqual(service.requests[0].start, "anchor")
        XCTAssertNil(service.requests[0].cursor)
        XCTAssertFalse(service.requests[0].search)

        service.finish(messages: [message("older"), message("anchor"), message("older")], cursor: "page-2")
        XCTAssertEqual(driver.messages.map { $0.messageId }, ["older", "anchor", "newer"])
        model.loadMessages()
        XCTAssertEqual(service.requests.last?.cursor, "page-2")
        service.finish(messages: [message("older"), message("anchor")], cursor: "page-3")
        model.loadMessages()
        XCTAssertEqual(service.requests.last?.cursor, "page-3", "An overlapping page must not end pagination")
        service.finish(messages: [message("oldest")], cursor: nil)
        model.loadMessages()
        XCTAssertEqual(service.requests.count, 3)
        XCTAssertEqual(driver.messages.map { $0.messageId }, ["oldest", "older", "anchor", "newer"])
    }

    @MainActor
    func testThreadShortPageContinuesAndFullFinalPageStops() {
        let service = PaginationService()
        let driver = PaginationDriver()
        driver.isThread = true
        let model = PaginationThreadViewModel(chatThread: nil, historyService: service)
        model.bindDriver(driver: driver, create: false)
        model.loadMessages()
        XCTAssertEqual(service.requests.count, 1)
        service.finish(messages: [message("first")], cursor: "next")
        XCTAssertEqual(driver.threadFinished, false)
        model.loadMessages()
        XCTAssertEqual(service.requests.last?.cursor, "next")
        service.finish(messages: (0..<20).map { message("final-\($0)") }, cursor: "")
        XCTAssertEqual(driver.threadFinished, true)
        model.loadMessages()
        XCTAssertEqual(service.requests.count, 2)
        XCTAssertEqual(driver.messages.count, 21)
    }

    @MainActor
    func testThreadFailureReleasesLoadingAndRetriesSameCursor() {
        let service = PaginationService()
        let driver = PaginationDriver()
        driver.isThread = true
        let model = PaginationThreadViewModel(chatThread: nil, historyService: service)
        model.bindDriver(driver: driver, create: false)
        service.finish(messages: [message("first")], cursor: "retry-page")
        model.loadMessages()
        service.finish(messages: [], cursor: nil, error: ChatError(description: "Offline", code: .networkUnavailable))
        XCTAssertEqual(driver.threadFinished, false)
        model.loadMessages()
        XCTAssertEqual(service.requests.count, 3)
        XCTAssertEqual(service.requests.last?.cursor, "retry-page")
    }

    private func message(_ id: String) -> ChatMessage {
        let value = ChatMessage(conversationID: "peer", body: ChatTextMessageBody(text: id), ext: nil)
        value.messageId = id
        return value
    }
}

private final class PaginationThreadViewModel: ChatThreadViewModel {
    override func threadCreateAlert() {}
}

private final class PaginationDriver: NSObject, IMessageListViewDriver {
    var messages: [ChatMessage] = []
    var isThread = false
    var threadFinished = false
    var firstMessageId: String { messages.first?.messageId ?? "" }
    var replyMessageId: String { "" }
    var dataSource: [ChatMessage] { messages }
    var scrolledBottom: Bool { false }
    func refreshMessages(messages: [ChatMessage]) { self.messages = messages }
    func insertMessages(messages: [ChatMessage]) {
        if isThread { self.messages.append(contentsOf: messages) }
        else { self.messages.insert(contentsOf: messages, at: 0) }
    }
    func updateThreadLoadMessagesFinished(finished: Bool) { threadFinished = finished }
    func addActionHandler(actionHandler: MessageListViewActionEventsDelegate) {}
    func removeEventHandler(actionHandler: MessageListViewActionEventsDelegate) {}
    func processMessage(operation: MessageOperation, message: ChatMessage) {}
    func showMessage(message: ChatMessage) { messages.append(message) }
    func updateMessageStatus(message: ChatMessage, status: ChatMessageStatus) {}
    func updateMessageAttachmentStatus(message: ChatMessage) {}
    func addMentionUserToField(user: ChatUserProfileProtocol) {}
    func updateAudioMessageStatus(message: ChatMessage, play: Bool) {}
    func updateGroupMessageChatThreadChanged(message: ChatMessage) {}
    func reloadTopic(message: ChatMessage) {}
    func reloadReaction(message: ChatMessage) {}
    func endRefreshing() {}
    func stopAudioMessagesPlay() {}
    func readAllMessages() {}
    func highlightMessage(message: ChatMessage) {}
}

private final class PaginationService: NSObject, ChatService {
    struct Request {
        let start: String
        let cursor: String?
        let search: Bool
    }
    var requests: [Request] = []
    private var completion: ((ChatError?, [ChatMessage], String?) -> Void)?
    func loadMessages(start messageId: String, cursor: String?, pageSize: UInt, searchMessage: Bool, completion: @escaping (ChatError?, [ChatMessage], String?) -> Void) {
        requests.append(Request(start: messageId, cursor: cursor, search: searchMessage))
        self.completion = completion
    }
    func fetchChatThreadHistoryMessages(conversationId: String, cursor: String?, pageSize: UInt, completion: @escaping (ChatError?, [ChatMessage], String?) -> Void) {
        requests.append(Request(start: "", cursor: cursor, search: false))
        self.completion = completion
    }
    func finish(messages: [ChatMessage], cursor: String?, error: ChatError? = nil) {
        let callback = completion
        completion = nil
        callback?(error, messages, cursor)
    }
    func bindChatEventsListener(listener: ChatResponseListener) {}
    func unbindChatEventsListener(listener: ChatResponseListener) {}
    func send(message: ChatMessage, completion: @escaping (ChatError?, ChatMessage?) -> Void) {}
    func edit(messageId: String, text: String, completion: @escaping (ChatError?, ChatMessage?) -> Void) {}
    func recall(messageId: String, completion: @escaping (ChatError?) -> Void) {}
    func removeLocalMessage(messageId: String) {}
    func removeHistoryMessages() {}
    func markMessageAsRead(messageId: String) {}
    func markAllMessagesAsRead() {}
    func searchMessage(keyword: String, pageSize: UInt, userId: String, completion: @escaping (ChatError?, [ChatMessage]) -> Void) {}
    func translateMessage(message: ChatMessage, completion: @escaping (ChatError?, ChatMessage?) -> Void) {}
    func reaction(reaction: String, message: ChatMessage, completion: @escaping (ChatError?) -> Void) {}
    func pinMessage(messageId: String, completion: @escaping (ChatError?) -> Void) {}
    func unpinMessage(messageId: String, completion: @escaping (ChatError?) -> Void) {}
    func pinnedMessages(conversationId: String, completion: @escaping ([ChatMessage]?, ChatError?) -> Void) {}
}
