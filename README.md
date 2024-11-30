# tcg-counter-app
Smartphone app for updating counter value on TCG counter

## Ideas

### Counter operations

- +1
- -1
- double (x2)
- clear
- undo

### New Game / App Restart

When the app is first started, it will not be tracking any TCG Counters. When a TCG Counter is in range for the first time, the user will be given the option to enter a name for tracking the device in the app. It is expected that this would be the card name the counter is on to make it easy to switch between the app and the board state. Each TCG Counter added would be displayed in a list with the given name and counter value.

### Multiple TCG Counter Device Tracking

This feature will allow counter values from multiple TCG Counter hardware devices to be tracked together. This would be especially useful for effects like proliferate or doubling counters on all creatures, etc. A single update could be made one time in the app to update all counter values and then the phone could be tapped to each device to update the displayed value. Each TCG Counter device has a unique id that can be used to create a hashmap with keys composed of the device ids and a counter object including the current value, card name, etc. as the map values. 

### Preselected chained operations

This feature would allow a chain of counter operations to be specified prior to tapping the tag and all counter updates could be done in one single tap to save time. For example say a Bristly Bill, Spine Sower and Kami of Whispered Hopes are on the battlefield each with +1/+1 counters on them. The ability to double the number of counters on each creature of Bristly Bill is activated. When that happens the ability on Kami to add an additional +1/+1 counter when one or more +1/+1 counters are added is triggered. These could be chained into a single update operation where the phone could just be tapped once to the tags on each creature rather than making updates while holding the phone against the tag for each one.

### Reading out large values from tag

The 7 segment display on the tag can only display numerical values from 0-99. If a value is larger than 99 the tag will display oF indicating an overflow. Players will only know that that value is larger than 99 by looking at the tag. To see the exact value the phone can be tapped to the tag and the actual value will be displayed on the phone. These values could also be stored along with the card name if desired for easy access without needing to tap the phone to the tag.

![oF-phone](https://github.com/user-attachments/assets/116c31b3-7aad-4ab9-a167-19b345e73ca3)

### Tracking

- counter instances
- power / toughness aggregate (similar to Arena)
  - could include base power / toughness with counters, enchantments, etc.
