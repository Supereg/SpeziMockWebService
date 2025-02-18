//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import Spezi


/// Mocks the interaction with a web service usable for testing and demonstration purposes.
///
/// > Important: If your application is not yet configured to use Spezi, follow the [Spezi setup article](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/setup) setup the core Spezi infrastructure.
/// 
/// The component needs to be registered in a Spezi-based application using the [`configuration`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/speziappdelegate/configuration)
/// in a [`SpeziAppDelegate`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/speziappdelegate):
/// ```swift
/// class ExampleAppDelegate: SpeziAppDelegate {
///     override var configuration: Configuration {
///         Configuration {
///             MockWebService()
///             // ...
///         }
///     }
/// }
/// ```
/// > Tip: You can learn more about a [`Component` in the Spezi documentation](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/component).
///
///
/// ## Usage
///
/// As the ``MockWebService`` conforms to [`ObservableObjectProvider`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/observableobjectprovider)
/// and [`ObservableObject`](https://developer.apple.com/documentation/combine/observableobject),
/// you can access it in a SwiftUI [`View`](https://developer.apple.com/documentation/swiftui/view)
/// using the [`@EnvironmentObject`](https://developer.apple.com/documentation/swiftui/environmentobject) dependency injection mechanism.
/// ```swift
/// struct FHIRMockWebServiceTestsView: View {
///     @EnvironmentObject var webService: MockWebService
///
///
///     var body: some View {
///         // ...
///     }
/// }
/// ```
///
/// > Tip: You can use a ``RequestList`` to display the mock requests in your Spezi-based application.
public actor MockWebService: Component, DefaultInitializable, ObservableObjectProvider, ObservableObject {
    @MainActor @Published var requests: [Request] = []
    
    
    /// Creates an instance of a ``MockWebService``.
    public init() { }
    
    
    /// Uploads a new resource to the mocked web service.
    /// - Parameters:
    ///   - path: The path the resources would be uploaded to.
    ///   - body: The content that would be uploaded to a web service.
    public func upload(path: String, body: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                requests.insert(Request(type: .add, path: path, body: body), at: 0)
                continuation.resume()
            }
        }
    }
    
    /// Removes a resource from the mocked web service.
    /// - Parameter path: The path of the resource that should be removed.
    public func remove(path: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                requests.insert(Request(type: .delete, path: path), at: 0)
                continuation.resume()
            }
        }
    }
}
