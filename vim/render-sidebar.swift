// Append a custom-bindings sidebar to the vim cheatsheet poster.
// called by gen-cheatsheet.sh; usage: swift render-sidebar.swift <keys.tsv> <base.png> <out.png>

import AppKit

let args = CommandLine.arguments
guard args.count == 4 else {
    FileHandle.standardError.write("usage: render-sidebar keys.tsv base.png out.png\n".data(using: .utf8)!)
    exit(1)
}

// rows grouped by section, in file order
var sections: [(String, [(String, String)])] = []
for line in try! String(contentsOfFile: args[1], encoding: .utf8).split(separator: "\n") {
    let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
    guard f.count == 3 else { continue }
    if sections.last?.0 != f[0] { sections.append((f[0], [])) }
    sections[sections.count - 1].1.append((f[1], f[2]))
}

guard let baseRep = NSImage(contentsOfFile: args[2])?.representations.first else {
    FileHandle.standardError.write("cannot read \(args[2])\n".data(using: .utf8)!)
    exit(1)
}
let baseW = baseRep.pixelsWide, baseH = baseRep.pixelsHigh
let sideW = 1500
let outW = baseW + sideW

let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: outW, pixelsHigh: baseH,
                           bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                           colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
rep.size = NSSize(width: outW, height: baseH)
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

func hex(_ v: Int) -> NSColor {
    NSColor(deviceRed: CGFloat((v >> 16) & 0xff) / 255, green: CGFloat((v >> 8) & 0xff) / 255,
            blue: CGFloat(v & 0xff) / 255, alpha: 1)
}
let white = hex(0xffffff), ink = hex(0x333333), red = hex(0x9b2b2c)
let barGrey = hex(0xb9b9b9), rowGrey = hex(0xdcdcdc), faint = hex(0x888888)

// poster on the left, white sidebar on the right
white.setFill(); NSRect(x: 0, y: 0, width: outW, height: baseH).fill()
baseRep.draw(in: NSRect(x: 0, y: 0, width: baseW, height: baseH))

// top-down layout helpers (AppKit's origin is bottom-left)
let left = CGFloat(baseW + 60), width = CGFloat(sideW - 110)
func box(_ top: CGFloat, _ h: CGFloat, _ c: NSColor, x: CGFloat = left, w: CGFloat = width) {
    c.setFill(); NSRect(x: x, y: CGFloat(baseH) - top - h, width: w, height: h).fill()
}
func text(_ s: String, _ top: CGFloat, _ h: CGFloat, x: CGFloat, font: NSFont, color: NSColor) {
    let a = NSAttributedString(string: s, attributes: [.font: font, .foregroundColor: color])
    let sz = a.size()
    a.draw(at: NSPoint(x: x, y: CGFloat(baseH) - top - h + (h - sz.height) / 2))
}

// size one unit so title + headers + rows fill the poster height
let rowCount = sections.reduce(0) { $0 + $1.1.count }
let margin: CGFloat = 70
let units = 3.2 + Double(sections.count) * 1.75 + Double(rowCount) * 1.0 + 0.9
let u = (CGFloat(baseH) - 2 * margin) / CGFloat(units)
let gap = u * 0.12

let keyFont = NSFont(name: "Menlo-Bold", size: u * 0.62)!
let labelFont = NSFont(name: "Helvetica", size: u * 0.40)!
let headFont = NSFont(name: "Helvetica-Bold", size: u * 0.52)!

var y = margin

// title banner in the vim-logo red
box(y, u * 2.6, red)
text("my vim", y, u * 1.7, x: left + u * 0.5, font: NSFont(name: "Georgia-Bold", size: u * 1.25)!, color: white)
text("custom bindings  ·  leader = -", y + u * 1.55, u * 0.9, x: left + u * 0.55,
     font: NSFont(name: "Helvetica", size: u * 0.46)!, color: white)
y += u * 3.2

let keyCol = u * 4.0
for (name, rows) in sections {
    y += u * 0.35
    box(y, u * 1.0, barGrey)
    text(name.uppercased(), y, u * 1.0, x: left + u * 0.3, font: headFont, color: ink)
    y += u * 1.0 + u * 0.4
    for (key, label) in rows {
        box(y, u - gap, rowGrey, w: keyCol - gap)
        box(y, u - gap, rowGrey, x: left + keyCol, w: width - keyCol)
        text(key, y, u - gap, x: left + u * 0.25, font: keyFont, color: ink)
        text(label, y, u - gap, x: left + keyCol + u * 0.3, font: labelFont, color: ink)
        y += u
    }
}

let stamp = DateFormatter(); stamp.dateFormat = "yyyy-MM-dd"
text("generated \(stamp.string(from: Date())) from vimrc", y + u * 0.2, u * 0.6,
     x: left, font: NSFont(name: "Helvetica", size: u * 0.32)!, color: faint)

NSGraphicsContext.current = nil
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: args[3]))
print("Wrote \(args[3])")
