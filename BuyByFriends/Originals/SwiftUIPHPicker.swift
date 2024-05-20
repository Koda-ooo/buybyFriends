//
//  SwiftUIPHPicker.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/30.
//

import Foundation
import SwiftUI
import PhotosUI
import os

public typealias PHPickerViewCompletionHandler = ( ([PHPickerResult]) -> Void)

public struct SwiftUIPHPicker: UIViewControllerRepresentable {
    // 1: PHPickerConfiguration は、外部から受け取ったものを使います
    var configuration: PHPickerConfiguration
    // 2: completionHandler は、([PHPickerResult]) -> Void の closure で、delegate が呼び出された時に呼ばれます。空であれば、PHPicker を閉じるだけです
    var completionHandler: PHPickerViewCompletionHandler?

    let logger = Logger(subsystem: "com.smalldesksoftware.SwiftUIPHPicker", category: "SwiftPHPicker")

    public init(configuration: PHPickerConfiguration, completion: PHPickerViewCompletionHandler? = nil) {
        self.configuration = configuration
        self.completionHandler = completion
    }

    public func makeCoordinator() -> Coordinator {
        logger.debug("makeCoordinator called")
        return Coordinator(self)
    }

    // 3: PHPickerViewController を生成した時に、Coordinator を delegate に設定します
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        logger.debug("makeUIViewController called")
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = context.coordinator
        return viewController
    }

    // 4: updateUIViewController は、現時点では空実装です
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        logger.debug("updateUIViewController called")
    }

    public class Coordinator: PHPickerViewControllerDelegate {
        let parent: SwiftUIPHPicker

        init(_ parent: SwiftUIPHPicker) {
            self.parent = parent
        }

        // 5: delegate メソッドは、Coordinator に実装しています
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.logger.debug("didFinishPicking called")
            picker.dismiss(animated: true)
            // 6: delegate が呼ばれた時に、初期化時に指定した closure を呼び出します
            self.parent.completionHandler?(results)
        }
    }
}
