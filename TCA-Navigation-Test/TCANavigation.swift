//
//  TestNavigation.swift
//  UIKitCaseStudies
//
//  Created by Matt Darnall on 2/18/25.
//  Copyright © 2025 Point-Free. All rights reserved.
//

import Foundation
import ComposableArchitecture
import UIKit
import SwiftUI


@Reducer
struct RootFeature {
    @Reducer
    enum Path {
        case feature1
        case feature2
    }
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case feature1Tapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case .feature1Tapped:
                state.path.append(Path.State.feature1)
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

final class StaticNavigationStackController: NavigationStackController {
    
    private var store: StoreOf<RootFeature>!
    
    convenience init(store: StoreOf<RootFeature>) {
        @UIBindable var bindable = store
        // Could not cast value of type 'RootFeature.Path.State' to 'ComposableArchitecture.StackState<RootFeature.Path.State>.Component' .
        
        // let sub: Store<StackState<RootFeature.Path.State>, StackAction<RootFeature.Path.State, RootFeature.Path.Action> > = store.scope(state: \.path, action: \.path)
        let storePath: UIBinding<Store<StackState<RootFeature.Path.State>, StackAction<RootFeature.Path.State, RootFeature.Path.Action>>> = $bindable.scope(state: \.path, action: \.path)
        
        self.init(
            path: storePath,
            root: {
                RootFeatureController(store: store)
            },
            destination: { store in
                switch store.case {
                case .feature1:
                    FeatureViewController(number: 1)
                case .feature2:
                    FeatureViewController(number: 2)
                }
            }
        )
        
        self.store = store
        
    }
    
    
}

final class RootFeatureController: UIViewController {
    private var store: StoreOf<RootFeature>!

    init(store: StoreOf<RootFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let feature1Button = UIButton(
            type: .system,
            primaryAction: UIAction { [weak self] _ in
                //self?.traitCollection.push(value: RootFeature.Path.State.feature1)
                self?.store.send(.feature1Tapped)
            })
        feature1Button.setTitle("Push feature 1", for: .normal)
        
        let feature2Button = UIButton(
            type: .system,
            primaryAction: UIAction { [weak self] _ in
                self?.traitCollection.push(value: RootFeature.Path.State.feature2)
            })
        feature2Button.setTitle("Push feature 2", for: .normal)
        
        
        let stack = UIStackView(arrangedSubviews: [
            feature1Button,
            feature2Button
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

private class FeatureViewController: UIViewController {
    let number: Int
    init(number: Int) {
        self.number = number
        super.init(nibName: nil, bundle: nil)
        title = "Feature \(number)"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let feature1Button = UIButton(
            type: .system,
            primaryAction: UIAction { [weak self] _ in
                self?.traitCollection.push(value: RootFeature.Path.State.feature1)
            })
        feature1Button.setTitle("Push feature 1", for: .normal)
        
        let feature2Button = UIButton(
            type: .system,
            primaryAction: UIAction { [weak self] _ in
                self?.traitCollection.push(value: RootFeature.Path.State.feature2)
            })
        feature2Button.setTitle("Push feature 2", for: .normal)
        
        let dismissButton = UIButton(
            type: .system,
            primaryAction: UIAction { [weak self] _ in
                self?.traitCollection.dismiss()
            })
        dismissButton.setTitle("Dismiss", for: .normal)
        
        let stack = UIStackView(arrangedSubviews: [
            feature1Button,
            feature2Button,
            dismissButton,
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

#Preview {
    StaticNavigationStackController(
        store: Store(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}

