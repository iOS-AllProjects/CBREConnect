//
//  BorderFloatLabelTextField.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/17/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

enum TextFieldValidatorOptions: String {
    case RequiredField = "This field is required"
    case Email = "Please enter an Email"
    case Numbers = "Please enter valid Numbers"
    case OneLowerCaseLetter = "Please enter 1 Lowercase Letter"
    case OneUpperCaseCahracter = "Please enter 1 Uppercase Letter"
    case OneNumerical = "Please enter 1 Numerical Character"
    case OneNonAlphanumerical = "Please enter 1 Non-Alphanumerical Character"
}

class TextFieldValidator {
    fileprivate var validationOptions: [TextFieldValidatorOptions]
    
    var minCharLength: Int?
    var customValidation: ((String)->String?)?
    
    init() {
        self.validationOptions = [TextFieldValidatorOptions]()
    }
    
    init(validationOptions options: [TextFieldValidatorOptions]) {
        self.validationOptions = options
    }
    
    func validate(_ text: String) -> String? {
        var validatorMessage = ""
        for option in validationOptions {
            switch option {
            case .RequiredField:
                if text.isEmpty { validatorMessage += "\(option.rawValue); " }
            case .Email:
                if !text.conformsToStringRegex("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$") {
                    validatorMessage += "\(option.rawValue); "
                }
            case .Numbers:
                if !text.conformsToStringRegex("^[0-9]+$") {
                    validatorMessage += "\(option.rawValue); "
                }
            case .OneLowerCaseLetter:
                if !text.conformsToStringRegex("([a-z]+)") { validatorMessage += "\(option.rawValue); " }
            case .OneUpperCaseCahracter:
                if !text.conformsToStringRegex("([A-Z]+)") { validatorMessage += "\(option.rawValue); " }
            case .OneNumerical:
                if !text.conformsToStringRegex("([0-9]+)") { validatorMessage += "\(option.rawValue); " }
            case .OneNonAlphanumerical:
                if !text.conformsToStringRegex("([^a-zA-Z\\d\\s:])") { validatorMessage += "\(option.rawValue); " }
            }
        }
        
        if let minCharLength = minCharLength {
            if text.characters.count < minCharLength {
                validatorMessage += "Please enter at least \(minCharLength) character\(minCharLength > 1 ? "s;" : ";") "
            }
        }
        
        if let customValidationMessage = customValidation?(text) {
            validatorMessage += "\(customValidationMessage); "
        }
        
        return validatorMessage == "" ? nil : validatorMessage
    }
}

@IBDesignable open class BorderFloatLabelTextField: UITextField {
    
    var validator = TextFieldValidator()
    var isValid: Bool { get { return (validator.validate(text!) ?? "") == "" } }
    
    /**
     The floating label that is displayed above the text field when there is other
     text in the text field.
     */
    open var floatingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fileprivate var bottomBorderLayer: CALayer?
    
    @IBInspectable open var requiredField: Bool = false  { didSet { setValidation() } }
    @IBInspectable open var emailValid: Bool = false     { didSet { setValidation() } }
    @IBInspectable open var numbersValid: Bool = false   { didSet { setValidation() } }
    @IBInspectable open var minCharLength: Int = 0       { didSet { setValidation() } }
    @IBInspectable open var oneLowerCase: Bool = false   { didSet { setValidation() } }
    @IBInspectable open var oneUpperCase: Bool = false   { didSet { setValidation() } }
    @IBInspectable open var oneNumerical: Bool = false   { didSet { setValidation() } }
    @IBInspectable open var oneNonAlphanumerical: Bool = false { didSet { setValidation() } }
    
    @IBInspectable open var bottomBorderEnabled: Bool = true {
        didSet {
            bottomBorderLayer?.removeFromSuperlayer()
            bottomBorderLayer = nil
            if bottomBorderEnabled {
                bottomBorderLayer = CALayer()
                bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - 1, width: bounds.width, height: 1)
                bottomBorderLayer?.backgroundColor = UIColor.gray.cgColor
                layer.addSublayer(bottomBorderLayer!)
            }
        }
    }
    
    @IBInspectable open var bottomBorderWidth: CGFloat = 1.0
    @IBInspectable open var bottomBorderColor: UIColor = UIColor.lightGray
    @IBInspectable open var bottomBorderHighlightWidth: CGFloat = 1.5
    
    /**
     The color of the floating label displayed above the text field when it is in
     an active state (i.e. the associated text view is first responder).
     
     @discussion Note: Default Color is blue.
     */
    @IBInspectable open var activeTextColorfloatingLabel : UIColor = UIColor.white {
        didSet {
            floatingLabel.textColor = activeTextColorfloatingLabel
        }
    }
    /**
     The color of the floating label displayed above the text field when it is in
     an inactive state (i.e. the associated text view is not first responder).
     
     @discussion Note: 70% gray is used by default if this is nil.
     */
    @IBInspectable open var inactiveTextColorfloatingLabel : UIColor = UIColor(white: 0.7, alpha: 1.0) {
        didSet {
            floatingLabel.textColor = inactiveTextColorfloatingLabel
        }
    }
    
    @IBInspectable open var topLabelSize: CGFloat = 10 {
        didSet {
            floatingLabel.font = UIFont.systemFont(ofSize: topLabelSize)
        }
    }
    
    /**
     default padding for floatingLabel
     */
    @IBInspectable open var verticalPadding : CGFloat = 0
    @IBInspectable open var horizontalPadding : CGFloat = 0
    
    /**
     Used to cache the placeholder string.
     */
    fileprivate var cachedPlaceholder = NSString()
    
    /**
     Used to draw the placeholder string if necessary. Starting value is true.
     */
    fileprivate var shouldDrawPlaceholder = true
    
    //MARK: Initializer
    //MARK: Programmatic Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    //MARK: Nib/Storyboard Initializers
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK: Unsupported Initializers
    init () {
        fatalError("Using the init() initializer directly is not supported. use init(frame:) instead")
    }
    
    //MARK: Deinit
    deinit {
        // remove observer
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: Setter & Getter
    override open var placeholder : String? {
        get {
            return super.placeholder
        }
        set (newValue) {
            super.placeholder = newValue
            if let text = newValue {
                cachedPlaceholder = text as NSString
                floatingLabel.text = self.cachedPlaceholder as String
                floatingLabel.sizeToFit()
            }
        }
    }
    
    override open var hasText :Bool {
        return !text!.isEmpty
    }
    
    //MARK: Setup
    fileprivate func setup() {
        setupObservers()
        setupFloatingLabel()
        applyFonts()
        setupViewDefaults()
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(BorderFloatLabelTextField.textFieldTextDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BorderFloatLabelTextField.fontSizeDidChange(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BorderFloatLabelTextField.textFieldTextDidBeginEditing(_:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(BorderFloatLabelTextField.textFieldTextDidEndEditing(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
    }
    
    fileprivate func setupFloatingLabel() {
        // Create the floating label instance and add it to the view
        floatingLabel.alpha = 1
        floatingLabel.center = CGPoint(x: horizontalPadding, y: verticalPadding)
        addSubview(floatingLabel)
        
        // Setup default colors for the floating label states
        floatingLabel.textColor = inactiveTextColorfloatingLabel
        floatingLabel.alpha = 0
        
    }
    
    fileprivate func applyFonts() {
        
        // set floatingLabel to have the same font as the textfield
        floatingLabel.font = UIFont(name: font!.fontName, size: topLabelSize)
    }
    
    fileprivate func setupViewDefaults() {
        
        // set vertical padding
        verticalPadding = 0.5 * self.frame.height
        
        // make sure the placeholder setter methods are called
        if let ph = placeholder {
            placeholder = ph
        } else {
            placeholder = ""
        }
    }
    
    //MARK: Validation
    fileprivate func setValidation() {
        var validationOptions = [TextFieldValidatorOptions]()
        if requiredField { validationOptions.append(.RequiredField) }
        if emailValid { validationOptions.append(.Email) }
        if numbersValid { validationOptions.append(.Numbers) }
        if oneLowerCase { validationOptions.append(.OneLowerCaseLetter) }
        if oneUpperCase { validationOptions.append(.OneUpperCaseCahracter) }
        if oneNonAlphanumerical { validationOptions.append(.OneNonAlphanumerical) }
        if oneNumerical { validationOptions.append(.OneNumerical) }
        validator = TextFieldValidator(validationOptions: validationOptions)
        if minCharLength != 0 { validator.minCharLength = minCharLength }
    }
    
    //MARK: - Drawing & Animations
    override open func layoutSubviews() {
        super.layoutSubviews()
        if (isFirstResponder && !hasText) {
            hideFloatingLabel()
        } else if(hasText) {
            showFloatingLabelWithAnimation(true)
        }
        
        bottomBorderLayer?.backgroundColor = isFirstResponder ? tintColor.cgColor : bottomBorderColor.cgColor
        let borderWidth = isFirstResponder ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - borderWidth, width: layer.bounds.width, height: borderWidth)
    }
    
    func showFloatingLabelWithAnimation(_ isAnimated : Bool)
    {
        let fl_frame = CGRect(
            x: horizontalPadding,
            y: 0,
            width: (self.floatingLabel.frame).width,
            height: (self.floatingLabel.frame).height
        )
        if (isAnimated) {
            let options: UIViewAnimationOptions = [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut]
            UIView.animate(withDuration: 0.2, delay: 0, options: options, animations: {
                self.floatingLabel.alpha = 1
                self.floatingLabel.frame = fl_frame
                }, completion: nil)
        } else {
            self.floatingLabel.alpha = 1
            self.floatingLabel.frame = fl_frame
        }
    }
    
    func hideFloatingLabel () {
        let fl_frame = CGRect(
            x: horizontalPadding,
            y: verticalPadding,
            width: (self.floatingLabel.frame).width,
            height: (self.floatingLabel.frame).height
        )
        let options: UIViewAnimationOptions = [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn]
        UIView.animate(withDuration: 0.2, delay: 0, options: options, animations: {
            self.floatingLabel.alpha = 0
            self.floatingLabel.frame = fl_frame
            }, completion: nil
        )
    }
    
    //MARK: - Auto Layout
    override open var intrinsicContentSize : CGSize {
        return sizeThatFits(frame.size)
    }
    
    // Adds padding so these text fields align with B68FloatingPlaceholderTextView's
    override open func textRect (forBounds bounds :CGRect) -> CGRect
    {
        return UIEdgeInsetsInsetRect(super.textRect(forBounds: bounds), floatingLabelInsets())
    }
    
    // Adds padding so these text fields align with B68FloatingPlaceholderTextView's
    override open func editingRect (forBounds bounds : CGRect) ->CGRect
    {
        return UIEdgeInsetsInsetRect(super.editingRect(forBounds: bounds), floatingLabelInsets())
    }
    
    //MARK: - Helpers
    fileprivate func floatingLabelInsets() -> UIEdgeInsets {
        floatingLabel.sizeToFit()
        return UIEdgeInsetsMake(
            floatingLabel.font.lineHeight,
            horizontalPadding,
            verticalPadding,
            horizontalPadding)
    }
    
    //MARK: - Observers
    func textFieldTextDidChange(_ notification : Notification) {
        let previousShouldDrawPlaceholderValue = shouldDrawPlaceholder
        shouldDrawPlaceholder = !hasText
        
        // Only redraw if self.shouldDrawPlaceholder value was changed
        if (previousShouldDrawPlaceholderValue != shouldDrawPlaceholder) {
            if (self.shouldDrawPlaceholder) {
                hideFloatingLabel()
            } else {
                showFloatingLabelWithAnimation(true)
            }
        }
    }
    
    //MARK: TextField Editing Observer
    func textFieldTextDidEndEditing(_ notification : Notification) {
        if hasText {
            floatingLabel.textColor = inactiveTextColorfloatingLabel
        }
        
        if let errorMessage = validator.validate(text!) {
            floatingLabel.textColor = UIColor.red
            floatingLabel.text = errorMessage
            showFloatingLabelWithAnimation(true)
        } else {
            floatingLabel.text = placeholder
        }
    }
    
    func textFieldTextDidBeginEditing(_ notification : Notification) {
        floatingLabel.textColor = activeTextColorfloatingLabel
        floatingLabel.text = placeholder
    }
    
    //MARK: Font Size Change Oberver
    func fontSizeDidChange (_ notification : Notification) {
        applyFonts()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
}

extension String {
    func conformsToStringRegex(_ stringRegex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: stringRegex, options: [])
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.characters.count)) != nil
        } catch { return false }
    }
}
