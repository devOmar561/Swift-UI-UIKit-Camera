#  ID3D iOS mid-level SwiftUI Test 03 Project

This test project is confidential.

## Time frame

For this take-home test project, you are given roughly 24 hours to complete what you can. There is no set submission time. 

If you'd like extra time to complete, please contact your technical interviewer(s).

If you are working full-time and would like to do this at night instead of on a day off, please coordinate with your technical interviewer(s).


## Requirements

These requirements are listed by importance, with vital items on the top and nice-to-have's at the bottom. You don't need to complete all requirements in the time frame.

### Required
0. Code should have inline documentation and main functions should be documented. An example of function documentation is in the `saveFile` function in the `StorageManager` class.
1. Integrate the `CameraController` and the view in `Main.storyboard` in the `camera` project into this SwiftUI project (`ID3D iOS mid-level SwiftUI Test 03`). Tapping on the card titled "Camera" should take you into the UIKit camera view to take pics. Pics are saved to local storage and, for test purposes, is also saved to your camera roll.
2. Adjust the call to the `saveFile` function in `StorageManager` to save to a subfolder for this capture session. Name the capture session to the `Date` (with time) the user first navigated to the integrated UIKit camera view.  
3. Metadata for each image captured should be saved to CoreData. There is a CoreData model called `Capture` for this purpose.
4. Add a label to the top of the camera view in `Main.storyboard`. As a user takes pictures, update the capture count in the label added.
5. After a user takes N pictures, the label above should display text that they have completed their capture session, wait 2 seconds, then automatically navigate back to the initial SwiftUI view that displays the "Camera" card. Set N to a random number between 3 and 8.
6. Add a button to the main view that says "Compress Last Session". This button should zip the folder with the images from the capture session. Also, add a ProgressView to the main view to show the progress for the zip above. Use the `zip` function in  `ArchiveManager` and leverage Combine as needed. When the progress view hits 100%, display an alert to let the user know it is done.

### Nice-to-have
7. Add another card called "History" that goes to another view that shows past sessions and their images. Style this as you see fit.
8. Strings and Colors should leverage `Localizable.strings` and `Colors.xcassets`.
9. Unit and UI tests can be added if time permits.


## Coding Guidelines

These coding guidelines should be adhered to where feasible.

### 1. Separation of concerns

Organize your code so that each section addresses a different concern.

### 2. Strive for zero compiler warnings in your IDE and zero runtime warnings in the debug console

Making quick fixes to silence compiler or runtime warnings will inevitably cause bugs and creates technical debt that is difficult to find and correct.

During development testing, observe the console and resolve any runtime warnings.

Take the time to fix the warning properly.

### 3. Check the native library/framework documentation first 

If an implementation feels like you are having to fix a native library or framework, or convert data through copious intermediaries, there is probably a more efficient way forward. 

Check the official documentation before you write bespoke algorithms.

### 4. Extensions are your friend

If there isn’t a native function for some logic that will be reused in different areas of the codebase, create an extension in a helper file.

### 5. Leverage coding paradigms based on the coding language

Use standard paradigms, such as object-oriented programming or protocol-oriented programming, based on the language you are developing in.

### 6. Handle errors in logic

If your preconditions aren’t met, return an error. Returning nothing creates phantom bugs that can be time-consuming to track down.

Same goes for do/catch blocks and failed promises closures. 

Make sure to handle as many specific errors as can be foreseen.

### 7. No stringly code 

Instead create enums or interfaces to use as values.

Implement this from the start instead of writing stringly test code.

### 8. Write generic code where suitable

Generic code helps avoid duplication and can reduce bugs. Use when appropriate.

### 9. Write code and comments that most junior-mid level developers can understand

Err on the side of clarity over brevity. 

This will make it easier for everyone to understand and will help more easily onboard new developers or seasoned polyglots picking up a new language.

Use standard naming conventions.

Be concise with your function and object names. 

Write inline comments to simply explain what your code does. 

It is easier to write even a poorly written comment than to revisit your code months later having forgotten what it was supposed to do. 

### 10. Document your code

Make inline comments that anyone can understand.

Key functions, extensions, classes, enums, etc. should be annotated with concise quick help information. 


