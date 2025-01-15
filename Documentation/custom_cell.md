# Fully Customizing Messages and Cells

Here, we use a red packet message as an example.

## 1.Inherit the Cell from chat_uikit based on the requirements.

```Swift
import UIKit
import chat_uikit

class RedPackageCell: CustomMessageCell {

    override func createContent() -> UIView {
        UIView(frame: self.contentView.bounds).backgroundColor(.clear).tag(bubbleTag).backgroundColor(.systemRed)
    }
    
    override func refresh(entity: MessageEntity) {
        super.refresh(entity: entity)
    }
            
        //If you want to change the color of the bubble’s arrow.
        override func updateAxis(entity: MessageEntity) {
        super.updateAxis(entity: entity)
        if Appearance.chat.bubbleStyle == .withArrow {
            self.bubbleWithArrow.arrow.image = UIImage(named: self.towards == .left ? "arrow_left": "arrow_right", in: .chatBundle, with: nil)?.withTintColor(self.towards == .left ? .systemRed:.systemRed)
        } else {
            self.bubbleMultiCorners.backgroundColor = .systemRed
        }
    }
}

```


[Image](./red_package_message.jpg)

## 2.Inherit the rendering model MessageEntity from chat_uikit based on the requirements, and define the bubble size. The redPackageIdentifier represents the event for the custom red packet message.

```Swift
import UIKit
import chat_uikit

final class MineMessageEntity: MessageEntity {
    
    override func customSize() -> CGSize {
        if let body = self.message.body as? ChatCustomMessageBody {
            switch body.event {
            case EaseChatUIKit_user_card_message:
                return CGSize(width: self.historyMessage ? ScreenWidth-32:limitBubbleWidth, height: contactCardHeight)
            case EaseChatUIKit_alert_message:
                let label = UILabel().numberOfLines(0).lineBreakMode(.byWordWrapping)
                label.attributedText = self.convertTextAttribute()
                let size = label.sizeThatFits(CGSize(width: ScreenWidth-32, height: 9999))
                return CGSize(width: ScreenWidth-32, height: size.height+50)
            case redPackageIdentifier:
                return CGSize(width: limitBubbleWidth, height: limitBubbleWidth*(5/3.0))
            default:
                return .zero
            }
            
        } else {
            return .zero
        }
    }

    
}


```

## 3.Add a new attachment message type for sending messages.


[Image](./send_red_package.jpg)

Example: Add the ability to send a red packet message.

```Swift
        
        let redPackage = ActionSheetItem(title: "红包".chat.localize, type: .normal,tag: "Red",image: UIImage(named: "photo", in: .chatBundle, with: nil))
        Appearance.chat.inputExtendActions.append(redPackage)
```

## 4.Handle the click of the newly added attachment message type in the inherited MessageListController.


```Swift
class CustomMessageListController: MessageListController {
    
    override func handleAttachmentAction(item: any ActionSheetItemProtocol) {
        switch item.tag {
        case "File": self.selectFile()
        case "Photo": self.selectPhoto()
        case "Camera": self.openCamera()
        case "Contact": self.selectContact()
        case "Red": self.redPackageMessage()
        default:
            break
        }
    }
    
    private func redPackageMessage() {
        self.viewModel.sendRedPackageMessage()
    }

}

let redPackageIdentifier = "redPackage"

```

## 5.Add a method to send a red packet message in the MessageListViewModel of chat_uikit.

```Swift
extension MessageListViewModel {
    func sendRedPackageMessage() {
        var ext = Dictionary<String,Any>()
        ext["something"] = "发红包"
        let json = ChatUIKitContext.shared?.currentUser?.toJsonObject() ?? [:]
        ext.merge(json) { _, new in
            new
        }
        let chatMessage = ChatMessage(conversationID: self.to, body: ChatCustomMessageBody(event: redPackageIdentifier, customExt: ["money": "20", "name": "张三","message": "恭喜发财大吉大利"]), ext: ext)
        self.driver?.showMessage(message: chatMessage)
        self.chatService?.send(message: chatMessage) { [weak self] error, message in
            if error == nil {
                if let message = message {
                    self?.driver?.updateMessageStatus(message: message, status: .succeed)
                }
            } else {
                consoleLogInfo("send text message failure:\(error?.errorDescription ?? "")", type: .error)
                if let message = message {
                    self?.driver?.updateMessageStatus(message: message, status: .failure)
                }
            }
        }
    }
    
    
}

```

## 6.Register all the inherited objects into chat_uikit after its initialization.


```Swift
        
        ComponentsRegister.shared.MessageRenderEntity = MineMessageEntity.self
        ComponentsRegister.shared.Conversation = MineConversationInfo.self
        ComponentsRegister.shared.MessageViewController = CustomMessageListController.self
        ComponentsRegister.shared.registerCustomizeCellClass(cellType: RedPackageCell.self)
```

- `ComponentsRegister.shared.Conversation = MineConversationInfo.self` is used to modify the display content of custom messages in the conversation list. When a new message is received in the conversation, the content is displayed as “[Red package]” for red packet messages. The main modification is made in the else block for non-text message types, where the custom message’s event is checked to display the corresponding content.

[Image](./red_package_placeholder.jpg)

```Swift
import UIKit
import chat_uikit


final class MineConversationInfo: ConversationInfo {
    
    override func contentAttribute() -> NSAttributedString {
        guard let message = self.lastMessage else { return NSAttributedString() }
        var text = NSMutableAttributedString()
        
        let from = message.from
        let mentionText = "Mentioned".chat.localize
        let user = ChatUIKitContext.shared?.userCache?[from]
        var nickName = user?.remark ?? ""
        if nickName.isEmpty {
            nickName = user?.nickname ?? ""
        }
        if nickName.isEmpty {
            nickName = from
        }
        if message.body.type == .text {
            var result = message.showType
            for (key,value) in ChatEmojiConvertor.shared.oldEmojis {
                result = result.replacingOccurrences(of: key, with: value)
            }
            text.append(NSAttributedString {
                AttributedText(result).foregroundColor(Theme.style == .dark ? UIColor.theme.neutralColor6:UIColor.theme.neutralColor5).font(UIFont.theme.bodyLarge)
            })
            let string = text.string as NSString
            for symbol in ChatEmojiConvertor.shared.emojis {
                if string.range(of: symbol).location != NSNotFound {
                    let ranges = text.string.chat.rangesOfString(symbol)
                    text = ChatEmojiConvertor.shared.convertEmoji(input: text, ranges: ranges, symbol: symbol,imageBounds: CGRect(x: 0, y: -3, width: 16, height: 16))
                    text.addAttribute(.font, value: UIFont.theme.bodyLarge, range: NSMakeRange(0, text.length))
                    text.addAttribute(.foregroundColor, value: Theme.style == .dark ? UIColor.theme.neutralColor6:UIColor.theme.neutralColor5, range: NSMakeRange(0, text.length))
                }
            }
            if self.mentioned {
                let showText = NSMutableAttributedString {
                    AttributedText("[\(mentionText)] ").foregroundColor(Theme.style == .dark ? UIColor.theme.primaryColor6:UIColor.theme.primaryColor5).font(Font.theme.bodyMedium)
                    AttributedText(nickName + ": ").foregroundColor(Theme.style == .dark ? UIColor.theme.neutralColor6:UIColor.theme.neutralColor5)
                }
                
                let show = NSMutableAttributedString(attributedString: text)
                show.addAttribute(.foregroundColor, value: Theme.style == .dark ? UIColor.theme.neutralColor6:UIColor.theme.neutralColor5, range: NSRange(location: 0, length: show.length))
                show.addAttribute(.font, value: UIFont.theme.bodyMedium, range: NSRange(location: 0, length: show.length))
                showText.append(show)
                return showText
            } else {
                let showText = NSMutableAttributedString {
                    AttributedText(message.chatType != .chat ? nickName + ": ":"").foregroundColor(Theme.style == .dark ? UIColor.theme.neutralColor6:UIColor.theme.neutralColor5).font(Font.theme.bodyMedium)
                }
                showText.append(text)
                showText.addAttribute(.foregroundColor, value: Theme.style == .dark ? UIColor.theme.neutralColor6:UIColor.theme.neutralColor6, range: NSRange(location: 0, length: showText.length))
                showText.addAttribute(.font, value: UIFont.theme.bodyMedium, range: NSRange(location: 0, length: showText.length))
                return showText
            }
        } else {
            var content = message.showContent
            if let body = message.body as? ChatCustomMessageBody,body.event == redPackageIdentifier {
                content = "[Red package]"
            }
            let showText = NSMutableAttributedString {
                AttributedText((message.chatType == .chat ? content:(nickName+":"+content))).foregroundColor(Theme.style == .dark ? UIColor.theme.neutralColor6:UIColor.theme.neutralColor5).font(UIFont.theme.bodyMedium)
            }
            return showText
        }
    }

}

```
