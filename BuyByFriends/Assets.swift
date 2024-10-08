// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let alert = ColorAsset(name: "Colors/alert")
    internal static let beige = ColorAsset(name: "Colors/beige")
    internal static let chromeYellow = ColorAsset(name: "Colors/chromeYellow")
    internal static let jetBlack = ColorAsset(name: "Colors/jetBlack")
    internal static let lightGray = ColorAsset(name: "Colors/lightGray")
    internal static let messageYellow = ColorAsset(name: "Colors/messageYellow")
    internal static let orange = ColorAsset(name: "Colors/orange")
    internal static let secondText = ColorAsset(name: "Colors/secondText")
    internal static let silver = ColorAsset(name: "Colors/silver")
    internal static let stormGreen = ColorAsset(name: "Colors/stormGreen")
    internal static let textLink = ColorAsset(name: "Colors/textLink")
    internal static let thirdText = ColorAsset(name: "Colors/thirdText")
    internal static let white = ColorAsset(name: "Colors/white")
  }
  internal enum Icons {
    internal static let circleCross = ImageAsset(name: "Icons/CircleCross")
    internal static let bookmark = ImageAsset(name: "Icons/bookmark")
    internal static let bug = ImageAsset(name: "Icons/bug")
    internal static let camera = ImageAsset(name: "Icons/camera")
    internal static let circleCrossAlert = ImageAsset(name: "Icons/circleCrossAlert")
    internal static let envelope = ImageAsset(name: "Icons/envelope")
    internal static let gallery = ImageAsset(name: "Icons/gallery")
    internal static let heart = ImageAsset(name: "Icons/heart")
    internal static let instagram = ImageAsset(name: "Icons/instagram")
    internal static let logo = ImageAsset(name: "Icons/logo")
    internal static let mail = ImageAsset(name: "Icons/mail")
    internal static let note = ImageAsset(name: "Icons/note")
    internal static let question = ImageAsset(name: "Icons/question")
    internal static let shoppingBag = ImageAsset(name: "Icons/shoppingBag")
    internal static let signout = ImageAsset(name: "Icons/signout")
    internal static let signoutAlert = ImageAsset(name: "Icons/signoutAlert")
    internal static let star = ImageAsset(name: "Icons/star")
    internal static let tiktok = ImageAsset(name: "Icons/tiktok")
    internal static let truck = ImageAsset(name: "Icons/truck")
    internal static let twitter = ImageAsset(name: "Icons/twitter")
    internal static let yen = ImageAsset(name: "Icons/yen")
  }
  internal enum Sns {
    internal static let etc = ImageAsset(name: "SNS/Etc")
    internal static let instagram = ImageAsset(name: "SNS/Instagram")
    internal static let line = ImageAsset(name: "SNS/LINE")
    internal static let link = ImageAsset(name: "SNS/Link")
    internal static let twitter = ImageAsset(name: "SNS/Twitter")
    internal static let monochromeInstagram = ImageAsset(name: "SNS/monochrome_Instagram")
  }
  internal static let main = ImageAsset(name: "main")
  internal static let noimage = ImageAsset(name: "noimage")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
