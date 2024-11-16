
# TableViewWrapper

**TableViewWrapper** is a powerful framework that bridges the gap between SwiftUI and UIKit, making it easier to work with `UITableView` while leveraging the declarative nature of SwiftUI. It provides advanced features like swipe actions, reordering, custom headers/footers, and scroll event handling—all within a SwiftUI-friendly interface.

## Features

- **SwiftUI Integration**: Embed SwiftUI views seamlessly into `UITableView` cells, headers, and footers.
- **Swipe Actions**: Add customizable leading and trailing swipe actions with support for destructive and non-destructive operations.
- **Row Selection**: Define actions triggered on row selection.
- **Reordering**: Enable row reordering with automatic data synchronization and custom reorder logic.
- **Scroll Event Handling**: Handle scrolling events like reaching the top, drag start/end, and content offset changes.
- **Custom Headers and Footers**: Easily add SwiftUI-based headers and footers at both the table and section levels.
- **Editable Rows**: Fine-tune row editing behaviors and disable indentation during editing.
- **Flexible Configuration**: Customize scrolling, bouncing, deceleration rates, and separator styles.

---

## Installation

### CocoaPods

1. Add the following line to your `Podfile`:

   ```ruby
   pod 'TableViewWrapper', :git => 'https://github.com/zakhar3009/TableViewWrapper.git', :tag => '0.0.1'
   ```

2. Run the installation command:

   ```bash
   pod install
   ```

### Swift Package Manager (SPM)

1. Open your project in Xcode.
2. Go to **File > Add Packages**.
3. Enter the repository URL:

   ```
   https://github.com/zakhar3009/TableViewWrapper.git
   ```

4. Select the desired version and add the package to your project.

---

## Usage

### Basic Table Example

Here’s how to set up a basic table with static rows using **TableViewWrapper**:

```swift
import SwiftUI
import TableViewWrapper

struct ContentView: View {
    @State private var data = [
        ["Row 1", "Row 2"],
        ["Row 3", "Row 4"]
    ]

    var body: some View {
        TableView(data: $data,
                  cellContentForData: { item in
                      Text(item)
                  },
                  header: {
                      Text("Table Header").font(.headline)
                  },
                  footer: {
                      Text("Table Footer").font(.footnote)
                  })
    }
}
```

---

### Adding Swipe Actions

```swift
TableView(data: $data,
          cellContentForData: { item in
              Text(item)
          })
.trailingSwipeActions([
    SwipeAction(title: "Delete",
                style: .destructive,
                handler: { indexPath in
                    print("Deleted item at \(indexPath)")
                })
])
.leadingSwipeActions([
    SwipeAction(title: "Edit",
                style: .normal,
                background: .blue,
                handler: { indexPath in
                    print("Edit item at \(indexPath)")
                })
])
```

---

### Row Reordering

Enable row reordering and handle reorder logic:

```swift
TableView(data: $data,
          cellContentForData: { item in
              Text(item)
          })
.canMoveRowAt { indexPath in
    // Allow all rows to be moved
    true
}
.onReorder {
    print("Row was reordered")
}
```

---

### Scroll Event Handling

React to scroll events like drag start/end and content offset changes:

```swift
TableView(data: $data,
          cellContentForData: { item in
              Text(item)
          })
.didScroll { offset in
    print("Scrolled to offset: \(offset)")
}
.beginDragging {
    print("Dragging started")
}
.endDragging { willDecelerate in
    print("Dragging ended. Will decelerate: \(willDecelerate)")
}
```

---

## Customization

### Headers and Footers

Add SwiftUI-based headers and footers for the entire table:

```swift
TableView(data: $data,
          cellContentForData: { item in
              Text(item)
          },
          header: {
              Text("Global Header")
          },
          footer: {
              Text("Global Footer")
          })
```

Or customize headers and footers for specific sections:

```swift
TableView(data: $data,
          cellContentForData: { item in
              Text(item)
          },
          sectionHeader: { section in
              Text("Section \(section)")
          },
          sectionFooter: { section in
              Text("Footer for Section \(section)")
          })
```

---

## License

TableViewWrapper is available under the MIT license. See the LICENSE file for more info.
