# Tapptic

# Notes :

## IF YOU ARE USING Xcode 10+ 
if you have this error message in console when building : libMobileGestalt MobileGestalt.c:890: MGIsDeviceOneOfType is not supported on this platform.
Please fix it by using Xcode 9.4.1 for building the app, it's a known issue :
https://stackoverflow.com/questions/50701321/xcode-error-on-simulation-mgisdeviceoneoftype-is-not-supported-on-this-platform/50724411#50724411

## Consignes : 

### Project : iOS Numbers Application (Light)
Typical workload : 2 hours


#### Description :

The iOS test application will be divided in two parts.
A master part that displays items from the json array available at http://dev.tapptic.com/test/json.php .
    
Each item cell will contain a text (name fields from ws) and an image (image fields from ws).
A touched cell will have a blue background with white text (for the time of being touched). A selected cell will have a red background with white text
Normal cells will have a transparent background with black text.
When the user clicks on a cell it will launch a second screen displaying :
A detail part containing an image and a text.
the text will display the "text" field of the json object available at http://dev.tapptic.com/test/json.php?name=xxx where xxx is the name field of the selected item from the list. The image will display the "image" field of the same json object.
When running on iPad and iPhone 6+ in landscape mode, the master and detail will be displayed in the same screen. In that case, the displayed item of the detail part will be selected in the master part. The first item of the master part should be selected by default.
When running on a tablet in portrait mode the app will work the same as on a smartphone.

#### Mandatory guidelines:

Warning : failing any of those following guidelines will disqualify you.
● The application will support iOS 8+
● The application should support any screen sizes / densities and support portrait and
landscape mode.
● Everything should be written by you : do not use auto generated templates and do not
copy / paste library or snippet from another developer.

#### General guidelines:

● Everything should be written in Objective­C or Swift (you should have been told to use one of them before this test begins)
● The application should never hang or crash.
● Prefer quality over speed : although the time taken will be part of the evaluation it’s
always better to take a little more time and deliver a perfect result than rushing an half
baked solution.
● Although the application is very small, do not take shortcuts. Architecture the application
like a normal size application. The evaluation will be based on your architecture choice, correctness, completeness, robustness and respect of the state of the art.
Bonus guidelines:
● The application will test the connectivity and ask for a retry if network is not available.
Third party libraries :
Only the following third party libraries will be tolerated :
SDWebImage
Use cases :
The following use cases WILL BE tested against your application. Failing one of those will disqualify you.

1) Launch the application on a tablet. Turn the tablet in portrait. The master part is displayed alone in portrait. Click on a cell. The detail screen should be displayed in portrait. Turn the tablet in landscape. The master and detail part should be displayed with the previously selected cell selected and displayed.

typical failure : the detail part is displayed alone in landscape
