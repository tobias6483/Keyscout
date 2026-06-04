import AppKit

@MainActor
final class ShortcutListWindowController: NSWindowController, NSSearchFieldDelegate, NSTableViewDataSource, NSTableViewDelegate {
    private let controller: KeyScoutController
    private let searchField = NSSearchField()
    private let sourceFilter = NSPopUpButton()
    private let summaryLabel = NSTextField(labelWithString: "")
    private let conflictLabel = NSTextField(wrappingLabelWithString: "Select a shortcut to inspect conflicts")
    private let tableView = NSTableView()
    private var rows: [ShortcutListRow] = []

    init(controller: KeyScoutController) {
        self.controller = controller

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 780, height: 460),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "KeyScout Shortcuts"
        window.minSize = NSSize(width: 620, height: 360)

        super.init(window: window)

        configureContent()
        reloadRows()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func refresh() {
        reloadRows()
    }

    func controlTextDidChange(_ notification: Notification) {
        reloadRows()
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        rows.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier, rows.indices.contains(row) else {
            return nil
        }

        let cell = NSTableCellView()
        let text = NSTextField(labelWithString: value(for: identifier, in: rows[row]))
        text.lineBreakMode = .byTruncatingTail
        text.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(text)

        NSLayoutConstraint.activate([
            text.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 8),
            text.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -8),
            text.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])

        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        updateConflictDetail()
    }

    @objc private func sourceFilterChanged() {
        reloadRows()
    }

    private func configureContent() {
        guard let contentView = window?.contentView else {
            return
        }

        let container = NSStackView()
        container.orientation = .vertical
        container.spacing = 12
        container.edgeInsets = NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        container.translatesAutoresizingMaskIntoConstraints = false

        let controls = NSStackView()
        controls.orientation = .horizontal
        controls.spacing = 10
        controls.alignment = .centerY

        searchField.placeholderString = "Search shortcuts"
        searchField.delegate = self
        searchField.translatesAutoresizingMaskIntoConstraints = false

        sourceFilter.addItems(withTitles: ["All Sources", "Accessibility", "Curated", "Manual"])
        sourceFilter.target = self
        sourceFilter.action = #selector(sourceFilterChanged)
        sourceFilter.translatesAutoresizingMaskIntoConstraints = false

        summaryLabel.textColor = .secondaryLabelColor
        summaryLabel.lineBreakMode = .byTruncatingTail

        conflictLabel.textColor = .secondaryLabelColor
        conflictLabel.maximumNumberOfLines = 4

        controls.addArrangedSubview(searchField)
        controls.addArrangedSubview(sourceFilter)
        controls.addArrangedSubview(summaryLabel)

        searchField.widthAnchor.constraint(greaterThanOrEqualToConstant: 220).isActive = true
        sourceFilter.widthAnchor.constraint(equalToConstant: 140).isActive = true

        configureTable()
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.documentView = tableView

        container.addArrangedSubview(controls)
        container.addArrangedSubview(scrollView)
        container.addArrangedSubview(conflictLabel)
        contentView.addSubview(container)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 260)
        ])
    }

    private func configureTable() {
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.headerView = NSTableHeaderView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 28

        addColumn("shortcut", title: "Shortcut", width: 110)
        addColumn("command", title: "Command", width: 180)
        addColumn("appName", title: "App", width: 150)
        addColumn("source", title: "Source", width: 110)
        addColumn("menuPath", title: "Menu Path", width: 240)
    }

    private func addColumn(_ id: String, title: String, width: CGFloat) {
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(id))
        column.title = title
        column.width = width
        column.minWidth = 80
        tableView.addTableColumn(column)
    }

    private func reloadRows() {
        rows = controller.latestShortcutListRows(filter: currentFilter)
        tableView.reloadData()
        summaryLabel.stringValue = "\(rows.count) of \(controller.latestShortcutCount) shortcuts"
        updateConflictDetail()
    }

    private var currentFilter: ShortcutListFilter {
        ShortcutListFilter(query: searchField.stringValue, source: selectedSource)
    }

    private var selectedSource: ShortcutSource? {
        switch sourceFilter.indexOfSelectedItem {
        case 1:
            return .accessibility
        case 2:
            return .curated
        case 3:
            return .manual
        default:
            return nil
        }
    }

    private func value(for identifier: NSUserInterfaceItemIdentifier, in row: ShortcutListRow) -> String {
        switch identifier.rawValue {
        case "appName":
            return row.appName
        case "shortcut":
            return row.shortcut
        case "command":
            return row.command
        case "menuPath":
            return row.menuPath
        case "source":
            return row.source
        default:
            return ""
        }
    }

    private func updateConflictDetail() {
        let selectedRow = tableView.selectedRow

        guard rows.indices.contains(selectedRow) else {
            conflictLabel.stringValue = rows.isEmpty
                ? "No shortcuts match the current filter"
                : "Select a shortcut to inspect conflicts"
            return
        }

        let row = rows[selectedRow]
        let conflicts = controller.conflictRows(for: row.keyboardShortcut)
        let details = conflicts
            .map { "\($0.appName) - \($0.command) - \($0.source)" }
            .joined(separator: "\n")

        conflictLabel.stringValue = [
            controller.conflictDetail(for: row.keyboardShortcut),
            details
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "\n")
    }
}
