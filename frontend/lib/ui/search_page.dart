import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:oiva_app_flutter/constants.dart';
import 'package:oiva_app_flutter/data/details_model.dart';
import 'package:oiva_app_flutter/data/suggestion_model.dart';
import 'package:oiva_app_flutter/fonts.dart';
import 'package:oiva_app_flutter/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../api/details_api.dart';
import '../api/suggestions_api.dart';
import 'about_page.dart';
import 'map_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  // Controllers
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _textEditingController = TextEditingController();
  AnimationController _loadingController;

  // States
  bool _isLoading = false;

  // Data
  SuggestionModel _currentItemSuggestion;
  DetailsModel _currentDetailsModel;
  final List<DetailsModel> _cart = <DetailsModel>[];

  @override
  void initState() {
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    _loadingController.repeat(reverse: true);
    super.initState();
  }

  void _loadItem(suggestion) async {
    _currentItemSuggestion = suggestion;
    setState(() {
      _isLoading = true;
    });
    _currentDetailsModel = await DetailsApi.fetchItem(suggestion.title);
    setState(() {
      _isLoading = false;
      _textEditingController.text = "";
    });
    if (_currentDetailsModel == null) {
      showError("ERR_FETCH_DETAILS");
    } else {
      _pageController.animateToPage(1,
          duration: defaultAnimationDuration, curve: defaultAnimationCurve);

      setState(() {
        _currentDetailsModel = _currentDetailsModel;
        _currentItemSuggestion = _currentItemSuggestion;
      });
    }
  }

  void showError(String code) {
    AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      dialogType: DialogType.ERROR,
      body: null,
      title: 'Tapahtui virhe!',
      desc: 'Koodi: ' + code,
      btnOkOnPress: () {},
      btnCancelOnPress: () {},
      btnOkText: "Ok",
    ).show();
  }

  Widget _getItemCells(BuildContext context, int index) {
    if (_currentDetailsModel == null) {
      showError("ILLEGAL_STATE");
      return Container();
    }

    switch (index) {
      case 0: // Header, title and details button
        return Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: const Border(
            bottom: BorderSide(
                width: defaultBorderWidth, color: AppColors.defaultForeground),
          ),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                (_currentItemSuggestion != null)
                    ? _currentItemSuggestion.title
                    : "null",
                style: AppFonts.regular(27),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Text(
                  "Text",
                  style: AppFonts.regular(12),
                ),*/
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 20,
                    child: ElevatedButton(
                      child: Text(AppLocalizations.of(context)
                          .searchInputSuggestionDetailsButton),
                      onPressed: () => _pageController.jumpToPage(3),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        primary: AppColors.defaultForeground,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 1: // Item category
        return Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: const Border(
            bottom: BorderSide(
                width: defaultBorderWidth, color: AppColors.defaultForeground),
          ),
          child: ListTile(
            title: Text(
              AppLocalizations.of(context).resultItemCategory,
              style: AppFonts.regular(22),
            ),
            subtitle: Text(
              _currentDetailsModel.getCategoryName(),
              style: AppFonts.itemCategory(_currentDetailsModel.getCategoryId(),
                  size: 14),
            ),
          ),
        );
      case 2: // Item recycle cost
        return Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: const Border(
            bottom: BorderSide(
                width: defaultBorderWidth, color: AppColors.defaultForeground),
          ),
          child: ListTile(
            title: Text(
              AppLocalizations.of(context).resultItemPrice,
              style: AppFonts.regular(22),
            ),
            subtitle: (_currentDetailsModel.getFreeToRecycle())
                ? Text(AppLocalizations.of(context).freeToRecycle,
                    style: AppFonts.regular(14, color: AppColors.green))
                : Text(AppLocalizations.of(context).notFreeToRecycle,
                    style: AppFonts.regular(14, color: AppColors.red)),
          ),
        );
      case 3: // Where to recycle
        return Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: const Border(
            bottom: BorderSide(
                width: defaultBorderWidth, color: AppColors.defaultForeground),
          ),
          child: ListTile(
            title: Text(
              AppLocalizations.of(context).resultItemDestination,
              style: AppFonts.regular(22),
            ),
            subtitle: (!_currentDetailsModel.getAllowedToRecycle())
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        child: Text(
                          AppLocalizations.of(context)
                              .resultNegativeDestination,
                          style: const TextStyle(fontSize: 17),
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          primary: AppColors.red,
                          onPrimary: AppColors.beige,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  )
                : Text(
                    AppLocalizations.of(context).resultDetailsAddress,
                    style: AppFonts.regular(14),
                  ),
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.defaultBackground,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: _pageController,
                children: <Widget>[
                  // This page is used when there is nothing to show
                  Container(
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          duration: defaultAnimationDuration,
                          opacity: (_isLoading ||
                                  _cart.isEmpty ||
                                  _pageController.page != 0)
                              ? 0
                              : 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1, vertical: 10),
                                    child: ElevatedButton(
                                      child: Text(AppLocalizations.of(context)
                                          .showCart),
                                      onPressed: () =>
                                          _pageController.jumpToPage(2),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        primary: AppColors.defaultForeground,
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AnimatedOpacity(
                          duration: defaultAnimationDuration,
                          opacity: (_isLoading) ? 1 : 0,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: _loadingController.value,
                              semanticsLabel: 'Ladataan..',
                              backgroundColor: AppColors.defaultBackground,
                              color: AppColors.defaultForeground,
                              strokeWidth: defaultBorderWidth,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/1_oamk.png",
                                    width: 86,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Image.asset(
                                    "assets/image/2_vipuvoimaa.png",
                                    width: 70,
                                  ),
                                  const SizedBox(
                                    width: 9,
                                  ),
                                  Image.asset(
                                    "assets/image/3_EU.png",
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Image.asset(
                                    "assets/image/4_pohjois-pohjanmaa.png",
                                    width: 70,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1, vertical: 10),
                                  child: AnimatedOpacity(
                                    duration: defaultAnimationDuration,
                                    opacity: (_isLoading) ? 0 : 1,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (!_isLoading) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AboutPage()));
                                        }
                                      },
                                      child: const Icon(
                                        Icons.info_outline,
                                        color:
                                            Color.fromARGB(255, 209, 209, 209),
                                        size: 33,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        elevation: 0,
                                        padding: const EdgeInsets.all(0),
                                        primary: Colors
                                            .transparent, // <-- Button color
                                        onPrimary:
                                            AppColors.white, // <-- Splash color
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // This page shows general item information and "add" button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          foregroundDecoration: BoxDecoration(
                              border: Border.all(
                                width: defaultBorderWidth,
                                color: AppColors.defaultForeground,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(defaultBorderRadius))),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                width: defaultBorderWidth,
                                color: AppColors.defaultForeground,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(defaultBorderRadius))),
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                return _getItemCells(context, index);
                              },
                              itemCount: 4),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Center(
                                child: (_currentDetailsModel == null)
                                    ? Container()
                                    : ElevatedButton(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .resultItemAddToCart,
                                          style: AppFonts.regular(22,
                                              color: AppColors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        onPressed: (!_currentDetailsModel
                                                .getAllowedToRecycle())
                                            ? null
                                            : () {
                                                setState(() {
                                                  _cart.add(
                                                      _currentDetailsModel);
                                                });
                                                _pageController.animateToPage(2,
                                                    duration:
                                                        defaultAnimationDuration,
                                                    curve:
                                                        defaultAnimationCurve);
                                                _textEditingController.text =
                                                    "";
                                              },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 22, vertical: 12),
                                          primary: (!_currentDetailsModel
                                                  .getAllowedToRecycle())
                                              ? AppColors.red
                                              : AppColors.defaultForeground,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // This page is the "shopping cart"
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 80, 20, 90),
                        child: Container(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  shape: const Border(
                                    bottom: BorderSide(
                                        width: defaultBorderWidth,
                                        color: AppColors.defaultForeground),
                                  ),
                                  child: ListTile(
                                    onTap: () => _pageController.animateToPage(
                                        1,
                                        duration: defaultAnimationDuration,
                                        curve: defaultAnimationCurve),
                                    trailing: IconButton(
                                      icon: Image.asset(
                                          'assets/icon/delete_icon.png'),
                                      iconSize: 30,
                                      onPressed: () {
                                        setState(() {
                                          _cart.removeAt(index);
                                        });
                                        if (_cart.isEmpty) {
                                          _pageController.jumpToPage(0);
                                        }
                                      },
                                    ),
                                    title: Text(
                                      _cart[index].getTitle(),
                                      style: AppFonts.regular(22),
                                    ),
                                    subtitle: Text(
                                      _cart[index].getCategoryName(),
                                      style: AppFonts.itemCategory(
                                          _currentDetailsModel.getCategoryId()),
                                    ),
                                  ),
                                );
                              },
                              itemCount: _cart.length),
                          clipBehavior: Clip.antiAlias,
                          foregroundDecoration: BoxDecoration(
                              border: Border.all(
                                width: defaultBorderWidth,
                                color: AppColors.defaultForeground,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(defaultBorderRadius))),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                width: defaultBorderWidth,
                                color: AppColors.defaultForeground,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(defaultBorderRadius))),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 80, 20, 20),
                              child: ElevatedButton(
                                child: Text(
                                  AppLocalizations.of(context).cartSubmit,
                                  style: AppFonts.regular(22,
                                      color: AppColors.white),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: (_cart.isNotEmpty)
                                    ? () => {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MapPage(cart: _cart)))
                                        }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 12),
                                  primary: AppColors.defaultForeground,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // This page shows the specific item properties
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                            width: defaultBorderWidth,
                            color: AppColors.defaultForeground,
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(defaultBorderRadius))),
                      foregroundDecoration: BoxDecoration(
                          border: Border.all(
                            width: defaultBorderWidth,
                            color: AppColors.defaultForeground,
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(defaultBorderRadius))),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: (_currentDetailsModel == null)
                                ? Container()
                                : Column(
                                    children: [
                                      ListTile(
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            _currentItemSuggestion.title,
                                            style: AppFonts.regular(27),
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Text(
                                            _currentDetailsModel
                                                .getCategoryName(),
                                            style: AppFonts.cursive(15),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: defaultBorderWidth,
                                        width: 1000,
                                        color: AppColors.defaultForeground,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Text(
                                          _currentDetailsModel.getDescription(),
                                          style: AppFonts.regular(16),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 110,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(defaultBorderRadius)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment(0.0,
                                        1), // 10% of the width, so there are ten blinds.
                                    colors: <Color>[
                                      Color.fromARGB(0, 255, 255, 255),
                                      AppColors.white
                                    ], // red to yellow
                                    tileMode: TileMode
                                        .clamp, // repeats the gradient over the canvas
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: ElevatedButton(
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .resultDetailsGoBack,
                                      style: AppFonts.regular(22,
                                          color: AppColors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () =>
                                        _pageController.jumpToPage(1),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22, vertical: 12),
                                      primary: AppColors.defaultForeground,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(), //
                      child: TypeAheadField(
                        hideOnLoading: false,
                        hideSuggestionsOnKeyboardHide: true,
                        hideOnEmpty: false,
                        hideOnError: true,
                        textFieldConfiguration: TextFieldConfiguration(
                          onTap: () {
                            if (!_isLoading) {
                              _pageController.jumpToPage(0);
                              _textEditingController.text = "";
                            }
                          },
                          controller: _textEditingController,
                          autofocus: false,
                          style: AppFonts.regular(18),
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(70, 20, 50, 0),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.defaultForeground,
                                      width: defaultBorderWidth),
                                  borderRadius: BorderRadius.circular(200.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.defaultForeground,
                                      width: defaultBorderWidth),
                                  borderRadius: BorderRadius.circular(200.0)),
                              filled: true,
                              hintStyle:
                                  AppFonts.regular(18, color: AppColors.gray),
                              hintText: AppLocalizations.of(context)
                                  .searchInputPlaceholder,
                              fillColor: AppColors.white),
                        ),
                        suggestionsCallback: (pattern) async {
                          if (pattern.isNotEmpty) {
                            List<SuggestionModel> suggestions =
                                await SuggestionsApi.fetchSuggestions(pattern);
                            if (suggestions == null) {
                              showError("ERR_FETCH_SEARCH");
                            }
                            return suggestions;
                          } else {
                            List<SuggestionModel> suggestions =
                                await SuggestionsApi.fetchSuggestions("aa");
                            if (suggestions == null) {
                              showError("ERR_FETCH_SEARCH");
                            }
                            return suggestions;
                          }
                        },
                        noItemsFoundBuilder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                AppLocalizations.of(context).searchNoResults),
                          );
                        },
                        loadingBuilder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(AppLocalizations.of(context).searching),
                          );
                        },
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            color: AppColors.cyan,
                            hasScrollbar: false,
                            shape: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.cyan,
                                    width: defaultBorderWidth),
                                borderRadius: BorderRadius.circular(26.0)),
                            elevation: 0),
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            contentPadding: const EdgeInsets.only(left: 20),
                            textColor: AppColors.navy,
                            title: Text(suggestion.title,
                                style: AppFonts.regular(18)),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          _textEditingController.text = suggestion.title;
                          _loadItem(suggestion);
                        },
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/icon/icon.png',
                  width: 90,
                  height: 90,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 29, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/icon/search_icon.png',
                        width: 27,
                        height: 27,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
