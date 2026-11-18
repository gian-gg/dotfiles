import AppKit

// Usage: appicon <bundle-id> <out.png> [canvas] [alpha]; writes the 64x64 app icon, centered on a transparent canvas if given.
// Build: swiftc -O appicon.swift -o appicon
let args = CommandLine.arguments
guard (3...5).contains(args.count),
      let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: args[1]) else { exit(1) }

let px = 64
let canvas = args.count >= 4 ? max(px, Int(args[3]) ?? px) : px
let alpha = args.count == 5 ? min(1, max(0, CGFloat(Double(args[4]) ?? 1))) : 1
let inset = CGFloat(canvas - px) / 2
let icon = NSWorkspace.shared.icon(forFile: url.path)
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: canvas, pixelsHigh: canvas, bitsPerSample: 8,
  samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
rep.size = NSSize(width: canvas, height: canvas)

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
icon.draw(in: NSRect(x: inset, y: inset, width: CGFloat(px), height: CGFloat(px)), from: .zero, operation: .sourceOver, fraction: alpha)
NSGraphicsContext.restoreGraphicsState()

guard let png = rep.representation(using: .png, properties: [:]) else { exit(1) }
try png.write(to: URL(fileURLWithPath: args[2]))
