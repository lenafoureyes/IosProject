//
//  LogInViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 25.07.2024.
//

import UIKit

class LogInViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    var loginDelegate: LoginViewControllerDelegate?
    private let factory = MyLoginFactory()
    private let authService = LocalAuthorizationService()
    
    private lazy var biometryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBiometryAuth), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = AppStyleGuide.Colors.darkBrown
        return indicator
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = AppStyleGuide.Colors.primaryBackground
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = AppStyleGuide.Colors.primaryBackground
        return contentView
    }()
    
    let logoImageView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "logo")
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.contentMode = .scaleAspectFit
        return logoView
    }()
    
    let emailTextField: UITextField = {
        let emailText = UITextField()
        emailText.placeholder = NSLocalizedString("email.phone", comment: "login email or phone")
        emailText.textColor = AppStyleGuide.Colors.darkBrown
        emailText.font = AppStyleGuide.Fonts.regular(size: 16)
        emailText.autocapitalizationType = .none
        emailText.keyboardType = .default
        emailText.returnKeyType = .done
        emailText.isUserInteractionEnabled = true
        emailText.translatesAutoresizingMaskIntoConstraints = false
        emailText.backgroundColor = .clear
        return emailText
    }()
    
    let passwordTextField: UITextField = {
        let passwordText = UITextField()
        passwordText.placeholder = NSLocalizedString("password", comment: "login password")
        passwordText.textColor = AppStyleGuide.Colors.darkBrown
        passwordText.font = AppStyleGuide.Fonts.regular(size: 16)
        passwordText.autocapitalizationType = .none
        passwordText.keyboardType = .default
        passwordText.returnKeyType = .done
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        passwordText.isUserInteractionEnabled = true
        passwordText.isSecureTextEntry = true
        passwordText.backgroundColor = .clear
        return passwordText
    }()
    
    let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = AppStyleGuide.Colors.secondaryBackground
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = AppStyleGuide.Colors.separator.cgColor
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let separatorView: UIView = {
        let separation = UIView()
        separation.backgroundColor = AppStyleGuide.Colors.separator
        separation.translatesAutoresizingMaskIntoConstraints = false
        return separation
    }()
    
    private var userService: UserService = {
        let avatarImage = UIImage(named: "cat") ?? UIImage()
        let user = User(login: "user123", fullName: "Meow Master", avatar: avatarImage, status: "mew")
        return CurrentUserService(user: user)
    }()
    
    private lazy var logButton: CustomButton = {
        let button = CustomButton(
            title: NSLocalizedString("button.login", comment: "button Log in"),
            titleColor: .white,
            cornerRadius: 10,
            useAutoLayout: false,
            font: AppStyleGuide.Fonts.bold(size: 18),
            masksToBounds: true
        )
        
        button.backgroundColor = AppStyleGuide.Colors.accentGreen
        button.layer.shadowColor = AppStyleGuide.Colors.darkBrown.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.1
        
        button.alpha = 1.0
        button.action = { [weak self] in
            self?.logButtonTapped()
        }
        
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        button.addTarget(self, action: #selector(buttonDisabled(_:)), for: .touchDragExit)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onAccountLocked = { [weak self] in
            self?.logButton.isEnabled = false
        }

        viewModel.onAccountUnlocked = { [weak self] in
            self?.logButton.isEnabled = true
        }
        
        viewModel.onLoginSuccess = { [weak self] user in
            let profileViewController = ProfileViewController()
            profileViewController.user = user
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        viewModel.onLoginFailure = { [weak self] message in
            self?.showAlert(message: message)
        }

        viewModel.onBiometryAvailable = { [weak self] configuration in
            self?.biometryButton.configuration = configuration
            self?.biometryButton.isHidden = false
        }
        
#if DEBUG
        userService = TestUserService()
#endif
        
        view.backgroundColor = AppStyleGuide.Colors.primaryBackground
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(inputStackView)
        contentView.addSubview(separatorView)
        contentView.addSubview(logButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(biometryButton)
        
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupConstraints()
        configureBiometryButton()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureBiometryButton() {
        var configuration = UIButton.Configuration.filled()
        
        switch authService.availableBiometryType {
        case .faceID:
            configuration.image = UIImage(systemName: "faceid")
            configuration.title = NSLocalizedString("face.id", comment: "")
        case .touchID:
            configuration.image = UIImage(systemName: "touchid")
            configuration.title = NSLocalizedString("touch.id", comment: "")
        default:
            biometryButton.isHidden = true
            return
        }
        
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = AppStyleGuide.Colors.accentGreen
        configuration.baseForegroundColor = .white
        
        biometryButton.configuration = configuration
        biometryButton.layer.shadowColor = AppStyleGuide.Colors.darkBrown.cgColor
        biometryButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        biometryButton.layer.shadowRadius = 6
        biometryButton.layer.shadowOpacity = 0.1
        biometryButton.isHidden = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            inputStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputStackView.heightAnchor.constraint(equalToConstant: 100),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            separatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            logButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            logButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logButton.heightAnchor.constraint(equalToConstant: 50),
            
            biometryButton.topAnchor.constraint(equalTo: logButton.bottomAnchor, constant: 16),
            biometryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            biometryButton.widthAnchor.constraint(equalToConstant: 200),
            biometryButton.heightAnchor.constraint(equalToConstant: 44),
            biometryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: logButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: logButton.centerYAnchor)
        ])
    }

    // Остальные методы остаются без изменений
    @objc private func logButtonTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        activityIndicator.startAnimating()
        logButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.checkCredentials(login: email, password: password)
            self.activityIndicator.stopAnimating()
            self.logButton.isEnabled = true
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("error.title", comment: "eror"),
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("error.ok", comment: "ok"), style: .default))
        present(alert, animated: true)
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 1.0
        }
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.8
        }
    }
    
    @objc private func buttonDisabled(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.3
            sender.setTitleColor(.gray, for: .normal)
        }
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc private func handleBiometryAuth() {
        authService.authorizeIfPossible { [weak self] success, error in
            if success {
                self?.performLoginWithBiometry()
            } else if let error = error {
                self?.showBiometryError(error)
            }
        }
    }
    
    private func performLoginWithBiometry() {
        let testLogin = "testUser"
        let testPassword = "123"
        
        emailTextField.text = testLogin
        passwordTextField.text = testPassword
        logButtonTapped()
    }
    
    private func showBiometryError(_ error: AuthorizationError) {
        let alert = UIAlertController(
            title: NSLocalizedString("biometric.eror", comment: ""),
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        if case .biometryNotEnrolled = error {
            alert.addAction(UIAlertAction(
                title: NSLocalizedString("settings", comment: ""),
                style: .default,
                handler: { _ in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
            ))
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
