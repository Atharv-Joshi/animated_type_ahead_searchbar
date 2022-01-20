import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AnimatedTypeAheadSearchBar extends StatefulWidget {
  final double? width;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final String? hintText;
  final bool? showPrefixIconTextField;
  final Widget? prefixIconTextField;
  final int? animationDurationInMilli;
  final Function? onSuffixTap;
  final bool? rtl;
  final bool? autoFocus;
  final bool? closeSearchOnSuffixTap;
  final Color? color;
  final Function? onListTileTap;
  final List? searchData;
  final Widget? loadingBuilder;
  final Widget? errorBuilder;
  final Widget? noItemsFoundBuilder;
  final bool? getImmediateSuggestions;
  final AutovalidateMode? autovalidateMode;
  final OverlayVisibilityMode? clearButtonMode;
  final BoxDecoration? textBoxDecoration;
  final EdgeInsets? textBoxPadding;
  final CupertinoSuggestionsBoxDecoration? suggestionBoxDecoration;

  const AnimatedTypeAheadSearchBar({
    Key? key,

    ///get immediate suggestions : default is false
    this.getImmediateSuggestions,

    /// autovalidate mode - always,disabled,on user interaction : default is disabled
    this.autovalidateMode,

    ///visibility of clear button - always,never,editing,notEditing : default is always
    this.clearButtonMode,

    ///decorationfor the type ahead textbox
    this.textBoxDecoration,

    ///padding for the textbox contents
    this.textBoxPadding,

    ///suggestions box decoration
    this.suggestionBoxDecoration,

    /// The width is required
    required this.width,

    ///suffixicon is optional
    this.suffixIcon = const Icon(
      Icons.close,
      size: 20.0,
    ),

    ///prefixicon is optional
    this.prefixIcon = const Icon(
      Icons.search,
      size: 20.0,
    ),

    ///hintText is optional,default value is Search
    this.hintText = 'Search...',

    ///
    this.animationDurationInMilli = 375,

    ///true by default
    this.showPrefixIconTextField = true,

    ///search icon is default value
    this.prefixIconTextField,

    ///searchData is required
    required this.searchData,

    //onListTileTap cannot be null
    required this.onListTileTap,

    /// choose your custom color
    this.color = Colors.white,

    /// The onSuffixTap cannot be null
    required this.onSuffixTap,

    /// make the search bar to open from right to left
    this.rtl = false,

    /// make the keyboard to show automatically when the searchbar is expanded
    this.autoFocus = true,

    /// close the search on suffix tap
    this.closeSearchOnSuffixTap = false,

    ///Default value is Container()
    this.loadingBuilder,

    ///Default value is Container()
    this.errorBuilder,

    ///Default value is Container()
    this.noItemsFoundBuilder,
  }) : super(key: key);

  @override
  _AnimatedTypeAheadSearchBarState createState() =>
      _AnimatedTypeAheadSearchBarState();
}

///toggle - 0 => false or closed
///toggle 1 => true or open
int toggle = 0;

class _AnimatedTypeAheadSearchBarState extends State<AnimatedTypeAheadSearchBar>
    with SingleTickerProviderStateMixin {
  ///initializing the AnimationController
  late AnimationController _con;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    ///Initializing the animationController which is responsible for the expanding and shrinking of the search bar
    _con = AnimationController(
      vsync: this,

      /// animationDurationInMilli is optional, the default value is 375
      duration: Duration(milliseconds: widget.animationDurationInMilli ?? 375),
    );
  }

  unfocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  final TextEditingController _typeAheadController = TextEditingController();
  final CupertinoSuggestionsBoxController _suggestionsBoxController =
      CupertinoSuggestionsBoxController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      // color: Colors.yellow,

      ///if the rtl is true, search bar will be from right to left
      alignment: widget.rtl ?? false
          ? Alignment.centerRight
          : const Alignment(-1.0, 0.0),

      ///Using Animated container to expand and shrink the widget
      child: AnimatedContainer(
        duration:
            Duration(milliseconds: widget.animationDurationInMilli ?? 375),
        height: 48.0,
        width: (toggle == 0)
            ? 48.0
            : widget.width ?? MediaQuery.of(context).size.width * 0.88,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          /// can add custom color or the color will be white
          color: widget.color ?? Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: -10.0,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Stack(
          children: [
            ///Using Animated Positioned widget to expand and shrink the widget
            AnimatedPositioned(
              duration: Duration(
                  milliseconds: widget.animationDurationInMilli ?? 375),
              top: 6.0,
              right: 7.0,
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    /// can add custom color or the color will be white
                    color: widget.color ?? Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: AnimatedBuilder(
                    child: GestureDetector(
                      onTap: () {
                        try {
                          ///trying to execute the onSuffixTap function
                          if (widget.onSuffixTap != null) {
                            widget.onSuffixTap!();
                          } else {
                            setState(() {
                              _typeAheadController.clear();
                            });
                          }

                          ///closeSearchOnSuffixTap will execute if it's true
                          if (widget.closeSearchOnSuffixTap == true) {
                            unfocusKeyboard();
                            setState(() {
                              toggle = 0;
                              _typeAheadController.clear();
                            });
                          }
                        } catch (e) {
                          ///print the error if the try block fails
                          developer.log(e.toString());
                        }
                      },

                      ///suffixIcon is of type Icon
                      child: widget.suffixIcon ??
                          const Icon(
                            Icons.close,
                            size: 20.0,
                          ),
                    ),
                    builder: (context, widget) {
                      ///Using Transform.rotate to rotate the suffix icon when it gets expanded
                      return Transform.rotate(
                        angle: _con.value * 2.0 * pi,
                        child: widget,
                      );
                    },
                    animation: _con,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(
                  milliseconds: widget.animationDurationInMilli ?? 375),
              left: (toggle == 0) ? 0.0 : 37.0,
              curve: Curves.easeOut,
              top: 5.0,

              ///Using Animated opacity to change the opacity of th textField while expanding
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  alignment: Alignment.topCenter,
                  width: widget.width != null
                      ? widget.width! * 0.78
                      : (MediaQuery.of(context).size.width * 0.88) * 0.78,
                  child: Material(
                    // color: Colors.transparent,
                    child: CupertinoTypeAheadFormField(
                      getImmediateSuggestions:
                          widget.getImmediateSuggestions ?? false,
                      autovalidateMode:
                          widget.autovalidateMode ?? AutovalidateMode.disabled,
                      animationDuration: const Duration(milliseconds: 0),
                      suggestionsBoxController: _suggestionsBoxController,
                      loadingBuilder: (c) {
                        return widget.loadingBuilder ?? Container();
                      },
                      errorBuilder: (context, o) {
                        return widget.errorBuilder ?? Container();
                      },
                      noItemsFoundBuilder: (context) {
                        return widget.noItemsFoundBuilder ?? Container();
                      },
                      textFieldConfiguration: CupertinoTextFieldConfiguration(
                        placeholder: widget.hintText ?? 'Search',
                        controller: _typeAheadController,
                        clearButtonMode: widget.clearButtonMode ??
                            OverlayVisibilityMode.always,
                        decoration: widget.textBoxDecoration ??
                            BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)),
                        padding: widget.textBoxPadding ??
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 9),
                        prefix: widget.showPrefixIconTextField ?? true
                            ? widget.prefixIconTextField ??
                                const Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: Icon(Icons.search),
                                )
                            : Container(),
                      ),
                      suggestionsBoxDecoration: widget.suggestionBoxDecoration ??
                          CupertinoSuggestionsBoxDecoration(
                              color: Colors.black,
                              border: Border.all(width: 0),
                              borderRadius: BorderRadius.circular(8)),
                      suggestionsCallback: (pattern) {
                        return Future.delayed(
                          const Duration(milliseconds: 200),
                          () async {
                            return getSuggestions(pattern);
                          },
                        );
                      },
                      itemBuilder: (context, String suggestion) {
                        return Material(
                          color: Colors.white,
                          borderOnForeground: false,
                          child: InkWell(
                            onTap: () => widget.onListTileTap!(suggestion),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          ),
                        );
                      },
                      onSuggestionSelected: (String suggestion) {
                        _typeAheadController.text = suggestion;
                      },
                    ),
                  ),
                ),
              ),
            ),

            ///Using material widget here to get the ripple effect on the prefix icon
            Material(
              /// can add custom color or the color will be white
              color: widget.color ?? Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              child: IconButton(
                splashRadius: 19.0,

                ///if toggle is 1, which means it's open. so show the back icon, which will close it.
                ///if the toggle is 0, which means it's closed, so tapping on it will expand the widget.
                ///prefixIcon is of type Icon
                icon: toggle == 1
                    ? const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )
                    : widget.prefixIcon ??
                        const Icon(
                          Icons.search,
                          size: 20.0,
                        ),

                onPressed: () {
                  setState(
                    () {
                      ///if the search bar is closed
                      if (toggle == 0) {
                        toggle = 1;
                        setState(() {
                          ///if the autoFocus is true, the keyboard will pop open, automatically
                          if (widget.autoFocus == true) {
                            FocusScope.of(context).requestFocus(focusNode);
                          }
                        });

                        ///forward == expand
                        _con.forward();
                      } else {
                        ///if the search bar is expanded
                        toggle = 0;

                        ///if the autoFocus is true, the keyboard will close, automatically
                        setState(() {
                          if (widget.autoFocus == true) unfocusKeyboard();
                          _typeAheadController.clear();
                        });

                        ///reverse == close
                        _con.reverse();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> getSuggestions(String pattern) {
    List<String> suggestions = [];
    if (pattern.length < 2) return suggestions;
    for (var i = 0; i < widget.searchData!.length; i++) {
      if (widget.searchData![i].toLowerCase().contains(pattern.toLowerCase())) {
        suggestions.add(widget.searchData![i]);
        // if (suggestions.length > 30) break;
      }
    }
    return suggestions;
  }
}
