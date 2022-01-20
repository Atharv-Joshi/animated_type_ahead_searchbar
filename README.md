# Animated Type Ahead SearchBar

This package merges [animated searchbar](https://pub.dev/packages/animated_search_bar) and [flutter typeahead](https://pub.dev/packages/flutter_typeahead) to give a animated type ahead search bar.

![Android Emulator - Pixel_5_API_29_5554 2022-01-08 13-17-39](https://user-images.githubusercontent.com/53505850/148636640-59b382de-12d0-47af-91d0-954519335f11.gif)





## Features

- Shows suggestions in an overlay that floats on top of other widgets
- Allows you to specify what the suggestions will look like through a builder function
- Allows you to specify what happens when the user taps a suggestion
- Provides high customizability; you can customize the suggestion box decoration

## Installation

Please refer to [these instructions](https://pub.dev/packages/animated_type_ahead_searchbar/install)

## Usage

```dart
  final List searchData = const [
    'Steel Pan',
    'Harp',
    'Cake',
    'Maracas',
    'Clarinet',
    'Odyssey',
    'Slide Whistle',
    'Piano',
  ];

  AnimatedTypeAheadSearchBar(
            width: MediaQuery.of(context).size.width * 0.88,
            onSuffixTap: null,
            itemBuilder: (String suggestion) {
              return Material(
                color: Colors.white,
                borderOnForeground: false,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          suggestion,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onSuggestionSelected: (suggestion) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(text: suggestion)));
              FocusScope.of(context).unfocus();
            },
            suggestionCallback: (String pattern) {
              List<String> suggestions = [];
              if (pattern.length < 2) return suggestions;
              for (var i = 0; i < searchData.length; i++) {
                if (searchData[i]
                    .toLowerCase()
                    .contains(pattern.toLowerCase())) {
                  suggestions.add(searchData[i]);
                }
              }
              return suggestions;
            },
          );
```

## Shoutout to the Developers

Huge thanks to the developers of [flutter_typeahead](https://pub.dev/packages/flutter_typeahead) and [animated_search_bar](https://pub.dev/packages/animated_search_bar) for such amazing packages.

## Future
Many optional parameters of [flutter_typeahead](https://pub.dev/packages/flutter_typeahead) and [animated_search_bar](https://pub.dev/packages/animated_search_bar) are not exposed currently to the user.
I plan to do so the users can use these packages at their full potential.

## Contribution
If you want to contibute please visit the github repository.

