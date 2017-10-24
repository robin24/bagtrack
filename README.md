# BagTrack

<img src=".github/AppIcon-256.png" alt="App Icon" width=128/>

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

## Prerequisites

In order to compile and use BagTrack, you need the following:
* Xcode 9.0 or later
* A physical device running iOS 11.0 or later (the app will not properly run in Simulator due to its use of Bluetooth)
* An iBeacon device

## Usage

1. Clone this repository and open BagTrack.xcodeproj in Xcode 9.0 or later
2. Compile and run BagTrack
3. Follow the instructions presented when opening the app
4. Add a new bag by tapping the "Add" button on the main screen
5. Provide a name, your iBeacon's UUID, major and minor values as well as its identifier, then tap "Save".
6. Keep your iBeacon in your bag or other luggage, BagTrack will indicate the approximate distance between you and your belongings while it is open, or send you a push notification when you get too far away while the app is in the background.
7. Enjoy!
