//
//  FooterView.swift
//  MusicApp
//
//  Created by andy on 02.03.2021.
//

import UIKit

class FooterView: UIView {
    private var label: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(hex: "#A1A5A9")
        return label
    }()
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoader() {
        loader.startAnimating()
        label.text = "LOADING"
    }
    
    func hideLoader() {
        loader.stopAnimating()
        label.text = nil
    }
    
    private func setupElements() {
        addSubview(label)
        addSubview(loader)
        
        loader.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8).isActive = true
    }
}
