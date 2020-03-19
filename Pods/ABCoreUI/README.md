# ABCoreUI

### CI/CD 
[CI Status]()

### Repository
[Git Hub Repo](https://github.com/J4U-Nimbus/ABCoreUI)

### Confluence
[Confluence](https://confluence.safeway.com/display/DMH/Modular+Pattern)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

To install it, simply add the following line to your Podfile:

```ruby
pod 'ABCoreUI'
```

To use the updated master Branch
```ruby
pod 'ABCoreUI', 
    :git => 'https://github.com/J4U-Nimbus/ABCoreUI' , 
    :branch => master
```

To use a specific stable version 
```ruby
pod 'ABCoreUI', 
    :git => 'https://github.com/J4U-Nimbus/ABCoreUI' , 
    '~> 1.2'
```


## Development 

Development and update of the common components can be done only with proper access provileges .
#### Step 1 . Download the original source with git clone to the following dir  
```ruby
https://github.com/J4U-Nimbus/ABCoreUI
```
#### Step 2. Link the source of the podfile to the local directory in the pod file of the main repo
```ruby
pod 'ABCoreUI', 
    :git => 'https://github.com/J4U-Nimbus/ABCoreUI' , 
    :source => <path to the local source of the library>
```

#### Step 3. If any changes needs to be pushed to the component library, use git commands in the source dir of component and not the main app.

## Author

jgasc12, 40179793+jgasc12@users.noreply.github.com

## License

ABCoreUI is available under the MIT license. See the LICENSE file for more info.
