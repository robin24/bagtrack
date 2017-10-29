# BagTrack

<img src="AppIcon-256.png" alt="App Icon" width=128 />

BagTrack is a lightweight iOS app written entirely in Swift. It allows users to track bags, suitcases and other belongings using Bluetooth iBeacons.

This application can be installed on any device running iOS 11+ and uses native iOS location tracking services for iBeacon tracking.
When tracked items move out of range, BagTrack sends out a push notification informing the user that they may be about to leave their belongings behind.

## License

BagTrack is distributed under the terms and conditions outlined in the MIT License.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## About iBeacon Technology

iBeacons are small, portable devices that send out Bluetooth Low Energy (Bluetooth LE) signals at regular intervals.
They are mostly used for providing indoor location services, but their small form factor makes them very suitable for bag and luggage tracking.

Although iBeacons come in various shapes and sizes, with various power options (batteries, AC power, solar, etc.), it is best to use a battery-powered device with a small footprint for tracking your belongings.
You can use any iBeacon device with BagTrack, as long as it conforms to Apple's iBeacon specs. For more information, visit [Apple's iBeacon site](https://developer.apple.com/ibeacon/).

## Prerequisites

In order to compile and use BagTrack, you need the following:
* Xcode 9.0 or later
* A physical device running iOS 11.0 or later (the app will not properly run in Simulator due to its use of Bluetooth)
* An iBeacon device

## Usage

1. Clone this repository.
`git clone https://github.com/robin24/bagtrack.git`
2. Open BagTrack.xcodeproj in Xcode 9.0 or later
3. Compile and run BagTrack
4. Follow the instructions presented when opening the app
5. Add a new bag by tapping the "Add" button on the main screen
6. Provide a name, your iBeacon's UUID, major and minor values as well as its identifier, then tap "Save".
7. Keep your iBeacon in your bag or other luggage, BagTrack will indicate the approximate distance between you and your belongings while it is open, or send you a push notification when you get too far away while the app is in the background.
8. Enjoy!

## FAQ

### How do I know that a particular iBeacon device conforms to Apple's iBeacon specifications?

In most cases, this will be indicated in the product name or description, or on the vendor's website. If you want to be 100% certain, contact the vendor before purchasing.

### When adding a new bag, I'm required to input a UUID, a major and minor value, as well as an identifier. Where do I find this information for my iBeacon?

Please check your device's manual or the manufacturer's website. In many cases, the manufacturer will have provided some method in which you can adjust those values to your own preferences, such as a corresponding app.

### Why do I need to type in all this information manually, anyways?

Unfortunately, this is due to a limitation in Apple's frameworks.
While the CoreBluetooth framework technically allows us to search for nearby Bluetooth devices, the device's UUID must be known before starting the auto-discovery process. Since iBeacon devices come with different, arbitrary UUIDs, it is therefore not possible to search for iBeacons automatically. For more information, take a look at [this Stack Overflow question](https://stackoverflow.com/questions/18784285/search-for-all-ibeacons-and-not-just-with-specific-uuid).

## Support

Have questions?
Post to our [Groups.io group](https://groups.io/g/bagtrack-users)