# How to register a custom class by inheriting an original one and customize it

All inheritable components are placed in `ComponentsRegister.swift`. You can inherit the original components and replace them.

## How to customize the location message cell

```Swift
class CustomLocationMessageCell: LocationMessageCell {
    //Create and return the view you want to display, and the bubble will wrap your view.
    @objc open override func createContent() -> UIView {
        UIView(frame: .zero).backgroundColor(.clear).tag(bubbleTag)
    }
}
//Register a custom class by inheriting an original one to replace the original one.
//Call this method before creating a message page or using other UI components.
ComponentsRegister.shared.ChatLocationCell = CustomLocationMessageCell.self
```

## 2. How to register a message type or style by inheriting a basic message type or style

```Swift
    ComponentsRegister.shared.registerCustomizeCellClass(cellType: YourMessageCell.self)
    class YourMessageCell: MessageCell {
        override func createAvatar() -> ImageView {
            ImageView(frame: .zero)
        }
    }
```

## 3. How to register a CustomMessagesViewModel by inheriting MessageListViewModel

```Swift
    //Inheriting the original class type
    class CustomMessagesViewModel: MessageListViewModel {
        override func loadMessages() {
            //If you want to make changes to the existing logic, you need to call the parent class implementation.
            super.loadMessages()
            //Otherwise, you don't need to call the parent class implementation.
        }
    }
    //Register the desired type        
    ComponentsRegister.shared.MessagesViewModel = CustomMessagesViewModel.self
```

## 4. How to register CustomMessagesViewController by inheriting MessageListViewController

```Swift
    class CustomMessagesViewController: MessageListViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    }
    ComponentsRegister.shared.MessageViewController = CustomMessagesViewController.self
```

## 5. Other modules are customized in the same way. Refer to the preceding customization examples. 
