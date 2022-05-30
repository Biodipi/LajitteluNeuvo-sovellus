import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_overlay_map/image_overlay_map.dart';
import 'package:oiva_app_flutter/colors.dart';
import 'package:oiva_app_flutter/data/details_model.dart';
import 'package:rubber/rubber.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../constants.dart';
import '../fonts.dart';
import 'feedback_page.dart';

class MapPage extends StatefulWidget {
  final List<Bin> _bins = [
    Bin(1, "paperi", 390, -335),
    Bin(2, "kasittelematon_puu", 441, -230),
    //Bin(2, "kasittelematon_puu", 488, -120),
    //Bin(2, "kasittelematon_puu", 522, -10),
    //Bin(2, "kasittelematon_puu", 552, 90),
    Bin(6, "pahvi", 589, 320),
    //Bin(3, "pahvi", 599, 430),
    //Bin(3, "pahvi", 594, 540),
    Bin(9, "metalli", 584, 650),
    //Bin(4, "metalli", 571, 760),
    Bin(11, "pienelektroniikka", 511, 910),
    Bin(12, "televisio", 356, 980),
    Bin(13, "lasi", 205, 960),
    Bin(14, "vanteelliset_renkaat", 96, 940),
    Bin(15, "vanteettomat_renkaat", -20, 911),
    Bin(16, "kodinkoneet", -125, 880),
    //Bin(9, "kodinkoneet", -229, 850),
    Bin(18, "kylmalaitteet", -580, 370),
    Bin(19, "tietotekniikka", -550, 260),
    Bin(20, "valaisimet", -499, 152),
    Bin(21, "muut", -450, 60),
    //Bin(14, "muut", -395, -45),
    //Bin(14, "muut", -330, -139),
    //Bin(15, "info", -260, -229),
  ];

  MapPage({Key key, this.cart}) : super(key: key);

  final List<DetailsModel> cart;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  RubberAnimationController _controller;
  AutoScrollController _scrollController;

  List<List<DetailsModel>> _sortedCart;
  ValueNotifier<bool> _valueNotifier = ValueNotifier(false);

  List<Bin> _markers;

  // Sort cart data
  List<List<DetailsModel>> _toMapOrder(List<DetailsModel> unorderedList) {
    List<List<DetailsModel>> orderedListRaw =
        List.filled(widget._bins.length, null);

    for (var i = 0; i < widget._bins.length; i++) {
      for (var item in unorderedList) {
        if (item.id == widget._bins[i].binId) {
          if (orderedListRaw[i] == null) {
            orderedListRaw[i] = [];
          }
          orderedListRaw[i].add(item);
        }
      }
    }

    // Remove nulls
    List<List<DetailsModel>> orderedList = [];
    for (int j = 0; j < orderedListRaw.length; j++) {
      var item = orderedListRaw[j];
      if (item != null) {
        orderedList.add(item);
      }
    }

    return orderedList;
  }

  @override
  void initState() {
    _scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    _sortedCart = _toMapOrder(widget.cart);
    _markers = _getMarkers();
    _controller = RubberAnimationController(
        vsync: this,
        lowerBoundValue: AnimationControllerValue(percentage: 0.08),
        halfBoundValue: AnimationControllerValue(percentage: 0.6),
        upperBoundValue: AnimationControllerValue(percentage: 0.6),
        duration: const Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: null,
          body: RubberBottomSheet(
            scrollController: _scrollController,
            lowerLayer: _getMap(),
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _controller.expand(),
                child: Container(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).progress +
                          " (" +
                          _getPlacedCount().toString() +
                          "/" +
                          _sortedCart.length.toString() +
                          ")",
                      style: AppFonts.regular(20, color: AppColors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [defaultBoxShadow()],
                      color: AppColors.defaultForeground,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(defaultBorderRadius),
                      )),
                ),
              ),
            ),
            headerHeight: 50,
            upperLayer: _getSheet(),
            animationController: _controller,
          )),
    );
  }

  Widget _getMap() {
    const Size imageSize = Size(2008, 2993);
    return Stack(
      children: <Widget>[
        Center(
          child: MapContainer(
              const Image(image: AssetImage('assets/image/map.png')), imageSize,
              markers: _getMarker(_markers, imageSize),
              markerWidgetBuilder: _getMarkerWidget,
              onTab: _onTap,
              onMarkerClicked: _onMarkerClicked),
        ),
      ],
    );
  }

  List<MarkerModel> _getMarker(List<Bin> bins, Size size) {
    List<MarkerModel> result = [];
    for (var element in bins) {
      double customOffsetY = 0;
      // Leaflet CRS.Simple, bounds = [[-height / 2, -width / 2], [height / 2, width / 2]]
      double dx = size.width / 2 + element.lng;
      double dy = size.height / 2 - element.lat + customOffsetY;
      // offset from left top
      result.add(MarkerModel(element, Offset(dx, dy)));
    }
    return result;
  }

  Widget _getMarkerWidget(double scale, MarkerModel data) {
    Bin facility = data.data;
    return SizedBox(
        height: 25,
        width: 25,
        child: AnimatedOpacity(
          duration: defaultAnimationDuration,
          opacity:
              (!_sortedCart[_idToIndex(facility.binId)].first.placed) ? 1 : 0,
          child: Container(
            decoration: BoxDecoration(
                color: (_isNextUp(facility.binId))
                    ? AppColors.red
                    : AppColors.gray,
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultBorderRadius))),
            child: Center(
                child: Text(
              (1 + _idToIndex(facility.binId)).toString(),
              style: const TextStyle(color: AppColors.white),
            )),
          ),
        ));

    //return const Icon(Icons.location_on, color: Colors.redAccent);
  }

  _onMarkerClicked(MarkerModel markerModel) {
    _controller.animateTo(to: 0.5);
    _scrollController.scrollToIndex(_idToIndex((markerModel.data as Bin).binId),
        preferPosition: AutoScrollPosition.begin);
  }

  _onTap() {
    // ignore: avoid_print
    print("tapped map");
    _valueNotifier.value = !_valueNotifier.value;
  }

  @override
  void dispose() {
    _valueNotifier.dispose();

    super.dispose();
  }

  Widget _getSheet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        foregroundDecoration: const BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(
            width: defaultBorderWidth,
            color: AppColors.defaultForeground,
          )),
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border.symmetric(
              vertical: BorderSide(
            width: defaultBorderWidth,
            color: AppColors.defaultForeground,
          )),
        ),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                // Last cell
                if (index == _sortedCart.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    child: Center(
                      child: ElevatedButton(
                        child: Text(
                          (_getPlacedCount() == _sortedCart.length)
                              ? AppLocalizations.of(context).buttonEnd
                              : AppLocalizations.of(context).buttonEnd,
                          style: AppFonts.regular(22, color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: (_getPlacedCount() < _sortedCart.length)
                            ? () {
                                AwesomeDialog(
                                  context: context,
                                  headerAnimationLoop: false,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.NO_HEADER,
                                  body: null,
                                  title: AppLocalizations.of(context)
                                      .dialogAreYourSureTitle,
                                  desc: AppLocalizations.of(context)
                                      .dialogAreYourSureText,
                                  btnOkOnPress: () {
                                    _finish();
                                  },
                                  btnCancelOnPress: () {},
                                  btnOkText:
                                      AppLocalizations.of(context).buttonAbort,
                                  btnCancelText:
                                      AppLocalizations.of(context).buttonCancel,
                                ).show();
                              }
                            : () {
                                _finish();
                              },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 5),
                          primary: (_getPlacedCount() < _sortedCart.length)
                              ? AppColors.red
                              : AppColors.red,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // Other items
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: _scrollController,
                  index: index,
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: const Border(
                      bottom: BorderSide(
                          width: defaultBorderWidth,
                          color: AppColors.defaultForeground),
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 35,
                              width: 35,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        defaultBorderRadius),
                                    color: (_isNextUp(_indexToId(index)))
                                        ? AppColors.red
                                        : AppColors.gray),
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                        color: AppColors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Flexible(
                              child: Text(
                                _sortedCart[index].first.getCategoryName() +
                                    ":",
                                maxLines: 3,
                                style: AppFonts.regular(22,
                                    color: AppColors.getWasteCategoryColor(
                                        _sortedCart[index]
                                            .first
                                            .getCategoryId())),
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _getTileForindex(index),
                      ),
                    ),
                  ),
                );
              },
              itemCount: _sortedCart.length + 1),
        ),
      ),
    );
  }

  List<Widget> _getTileForindex(int index) {
    List<Widget> items = [];

    for (var i = 0; i < _sortedCart[index].length; i++) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(left: 49),
          child: Text(
            "•  " + _sortedCart[index][i].getTitle(),
            style: AppFonts.regular(18),
          ),
        ),
      );
    }

    items.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Center(
        child: ElevatedButton(
          child: Text(
            (_sortedCart[index].first.placed)
                ? AppLocalizations.of(context).mapItemPlaced
                : AppLocalizations.of(context).mapPlaceItem,
            style: AppFonts.regular(22, color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            setState(() {
              _sortedCart[index].first.togglePlaced();
            });
            if (_sortedCart[index].first.placed) {
              if (_sortedCart.length == _getPlacedCount()) {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
                _controller.animateTo(to: _controller.upperBound);
              } else {
                _controller.collapse();
              }
            }
            /*if (_sortedCart.length == _getPlacedCount()) {
              AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                animType: AnimType.SCALE,
                dialogType: DialogType.SUCCES,
                body: null,
                title: AppLocalizations.of(context).dialogFinishTitle,
                desc: AppLocalizations.of(context).dialogFinishText,
                btnOkOnPress: () {
                  _finish();
                },
                btnCancelOnPress: () {},
                btnOkText: AppLocalizations.of(context).buttonYes,
                btnCancelText: AppLocalizations.of(context).buttonCancel,
              ).show();
            }*/
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
            primary: (_sortedCart[index].first.placed)
                ? AppColors.gray
                : AppColors.green,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      ),
    ));
    return items;
  }

  int _getPlacedCount() {
    int count = 0;

    for (var item in _sortedCart) {
      if (item.first.placed) {
        count++;
      }
    }

    return count;
  }

  void _finish() {
    AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      dialogType: DialogType.SUCCES,
      body: null,
      title: AppLocalizations.of(context).dialogEndTitle,
      desc: AppLocalizations.of(context).dialogEndText,
      btnOkOnPress: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => FeedbackPage()));
      },
      btnCancelOnPress: () {
        SystemNavigator.pop();
      },
      btnOkText: AppLocalizations.of(context).buttonOk,
      btnCancelText: AppLocalizations.of(context).buttonNoThanks,
    ).show();
  }

  int _idToIndex(int binId) {
    for (var i = 0; i < _sortedCart.length; i++) {
      if (_sortedCart[i].first.id == binId) return i;
    }
    return 0;
  }

  int _indexToId(int index) {
    return _sortedCart[index].first.id;
  }

  bool _isNextUp(int binId) {
    for (var i = 0; i < _sortedCart.length; i++) {
      if (_sortedCart[i].first.id == binId &&
          !_sortedCart[i].first.placed &&
          i - 1 >= 0 &&
          _sortedCart[i - 1].first.placed) {
        return true;
      } else if (_sortedCart[i].first.id == binId &&
          !_sortedCart[i].first.placed &&
          i - 1 < 0) return true;
    }
    return false;
  }

  List<Bin> _getMarkers() {
    List<Bin> markers = [];
    for (var i = 0; i < _sortedCart.length; i++) {
      for (var bin in widget._bins) {
        if (_sortedCart[i].first.id == bin.binId) markers.add(bin);
      }
    }
    return markers;
  }
}

class Bin {
  int binId;
  String name;

  double lng;
  double lat;

  Bin(this.binId, this.name, this.lng, this.lat);
}
