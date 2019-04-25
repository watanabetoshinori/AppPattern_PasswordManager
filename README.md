# AppPattern: PasswordManager

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![AppIcon](Preview/AppIcon.png)

This is an implementation example of an application feature called "PasswordManager".
The PasswordManager manages usernames and passwords for sites.

- [Features](#Features)
- [Requirements](#requirements)
- [Author](#author)
- [License](#license)

## Features
- [x] Sample code of AuthenticationServices framework.
- [x] List passwords.
- [x] Add or Edit passwoed.
- [x] Support QuickType.
- [x] Lock screen.

## Requirements

* iOS 12.0+
* Xcode 10.0+
* Swift 4.2+

### Setup

1. Create an AppID with `App Groups` and `AutoFill Credential Provider` enabled.

   ![setup1](Preview/setup1.png)

2. Update `Bundle Identifier` and `Signing` to match created AppID.

   ![setup2](Preview/setup2.png)

3. Update values both Container App and Extension.

   ![setup3](Preview/setup3.png)

4. Update value of [AppGroup.swift](PasswordManager/AppGroup.swift) file.

	```swift
	let appGroup = "group.dev.yourcompany.PasswordManager"
	```

## Screenshots

![Preview1](Preview/preview1.png)
![Preview2](Preview/preview2.png)
![Preview3](Preview/preview3.png)
![Preview4](Preview/preview4.png)

## Author

Watanabe Toshinori – toshinori_watanabe@tiny.blue

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
