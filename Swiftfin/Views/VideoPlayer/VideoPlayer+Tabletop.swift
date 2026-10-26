//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2026 Jellyfin & Jellyfin Contributors
//

import UIKit

// Foldable APIs require the iOS 27.1 SDK, which ships with Swift 6.4.
// Older toolchains compile these to no-ops.

extension UIView {

    /// The fold's frame when the device rests partially folded with the
    /// hinge running horizontally across this view, as in a tabletop pose.
    var tabletopFold: CGRect? {
        #if compiler(>=6.4)
        if #available(iOS 27.1, *) {
            return reservedRegions(kind: .division)
                .first { region in
                    region.isActive &&
                        region.frame.width > region.frame.height &&
                        region.frame.minY > bounds.minY &&
                        region.frame.maxY < bounds.maxY
                }?
                .frame
        }
        #endif
        return nil
    }

    /// Whether this view's window is on a display with a fold, folded or flat.
    var isOnFoldingDisplay: Bool {
        #if compiler(>=6.4)
        if #available(iOS 27.1, *), let window {
            return window.reservedRegions(kind: .division, options: .includeInactive).isNotEmpty
        }
        #endif
        return false
    }

    /// Lay out again when the hinge moves, since folding can change
    /// reserved regions without changing size or safe area insets.
    func addHingeLayoutTrigger() {
        #if compiler(>=6.4)
        if #available(iOS 27.1, *) {
            addInteraction(
                UIHingeInteraction { [weak self] _, _ in
                    self?.setNeedsLayout()
                }
            )
        }
        #endif
    }
}
