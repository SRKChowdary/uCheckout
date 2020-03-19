# ABCoreNetwork

### CI/CD 
[CI Status](https://app.bitrise.io/app/c09667990007add3#)

### Repository
[Git Hub Repo](https://github.com/J4U-Nimbus/ABCoreNetwork)

### Confluence
[Confluence](https://confluence.safeway.com/display/DMH/Modular+Pattern)

## Example

To run the  project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
The app should use Cocoapods as its dependency management system

## Installation

ABCoreNetwork is available through [CocoaPods](https://cocoapods.org). 
To install it, simply add the following line to your Podfile:

To use the updated master Branch
```ruby
pod 'ABCoreNetwork', 
    :git => 'https://github.com/J4U-Nimbus/ABCoreNetwork' , 
    :branch => master
```

To use a specific stable version 
```ruby
pod 'ABCoreNetwork', 
    :git => 'https://github.com/J4U-Nimbus/ABCoreNetwork' , 
    '~> 1.2'
```

Run pod commands in the terminal to install the library in the main repo
```ruby
pod install
```
## Development 
Development and update of the common components can be done only with proper access provileges .
#### Step 1 . Download the original source with git clone to the following dir  
```ruby
https://github.com/J4U-Nimbus/ABCoreNetwork
```
#### Step 2. Link the source of the podfile to the local directory in the pod file of the main repo
```ruby
pod 'ABCoreNetwork', 
    :git => 'https://github.com/J4U-Nimbus/ABCoreNetwork' , 
    :source => <path to the local source of the library>
```

#### Step 3. If any changes needs to be pushed to the component library, use git commands in the source dir of component and not the main app.

## Version Information 

### Release : (POC) - 0.1.0
### Author : gredd03, gredd03@safeway.com
### Changes : Initial Release 

## License

ABCoreNetwork is owned by Albertsons Inc . 2019
