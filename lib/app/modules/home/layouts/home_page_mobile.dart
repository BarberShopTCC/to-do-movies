import 'package:animations/animations.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:location/location.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:to_do_list/app/modules/home/components/card_movie_widget.dart';
import 'package:to_do_list/app/modules/home/components/menu_widget.dart';
import 'package:to_do_list/app/modules/home/home_controller.dart';
import 'package:to_do_list/app/modules/home/pages/add_movie/add_movie_page.dart';
import 'package:to_do_list/app/modules/home/pages/details/details_page.dart';
import 'package:to_do_list/app/shared/styles/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePageMobile extends StatefulWidget {
  final LocationData? location;

  const HomePageMobile({Key? key, this.location}) : super(key: key);

  @override
  _HomePageMobileState createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  final controller = Modular.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: controller.drawerController,
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      backgroundColor: Colors.grey[300]!,
      slideWidth: MediaQuery.of(context).size.width * .65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
      style: DrawerStyle.DefaultStyle,
      menuScreen: MenuWidget(
        location: widget.location,
      ),
      mainScreen: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = Modular.get<HomeController>();

  late FocusNode myFocusNode;

  @override
  void initState() {
    // controller.massInsert();
    // controller.loadMovies();
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ValueListenableBuilder<DrawerState>(
      valueListenable: ZoomDrawer.of(context)!.stateNotifier!,
      builder: (context, value, child) => AbsorbPointer(
        absorbing: value != DrawerState.closed,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xFFEAEDF0),
          body: Container(
            width: size.width,
            height: size.height,
            child: OrientationLayoutBuilder(
              portrait: (context) => Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height * .8,
                      child: Observer(
                        builder: (context) => controller.searchTerm.isNotEmpty
                            ? controller.searchResult.isEmpty
                                ? Center(
                                    child: Text(
                                      "Nenhum item corresponde a busca.",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                : AnimationLimiter(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: controller.searchResult.length,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: 10,
                                      ),
                                      itemBuilder: (context, index) =>
                                          AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        child: SlideAnimation(
                                          horizontalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: CardMovieWidget(
                                              controller:
                                                  controller.slidableController,
                                              movie: controller
                                                  .searchResult[index],
                                              expanded: controller
                                                          .expandedItemIndex ==
                                                      index
                                                  ? true
                                                  : false,
                                              onTap: () =>
                                                  controller.expandItem(index),
                                              onDismissed: (direction) {
                                                print(direction);
                                                if (direction ==
                                                    DismissDirection
                                                        .horizontal) {}
                                                controller.removeMovie(index);
                                              },
                                              onDelete: () =>
                                                  controller.removeMovie(index),
                                              onEdit: () {
                                                Modular.to.pushNamed(
                                                    '/home/add-movie');
                                              },
                                              onTapDetails: () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            : AnimationLimiter(
                                key: UniqueKey(),
                                child: ListView.separated(
                                  padding: EdgeInsets.only(bottom: 80, top: 15),
                                  shrinkWrap: true,
                                  itemCount: controller.movies.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: SlideAnimation(
                                        horizontalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: OpenContainer(
                                              // middleColor: Colors.red.withOpacity(.5),
                                              transitionType:
                                                  ContainerTransitionType
                                                      .fadeThrough,
                                              closedElevation: 0,
                                              closedShape:
                                                  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              transitionDuration:
                                                  Duration(milliseconds: 300),
                                              openBuilder: (context, action) =>
                                                  DetailsPage(
                                                movie: controller.movies[index],
                                              ),
                                              closedBuilder:
                                                  (context, action) => Observer(
                                                builder: (context) =>
                                                    CardMovieWidget(
                                                  controller: controller
                                                      .slidableController,
                                                  movie:
                                                      controller.movies[index],
                                                  expanded: controller
                                                              .expandedItemIndex ==
                                                          index
                                                      ? true
                                                      : false,
                                                  onTap: () => controller
                                                      .expandItem(index),
                                                  onDismissed: (direction) {
                                                    print(direction);
                                                    if (direction ==
                                                        DismissDirection
                                                            .horizontal) {}
                                                    controller
                                                        .removeMovie(index);
                                                  },
                                                  onDelete: () {
                                                    return controller
                                                        .removeMovie(index);
                                                  },
                                                  onEdit: () async {
                                                    var updated = await Modular
                                                        .to
                                                        .pushNamed<bool>(
                                                      '/home/add-movie',
                                                      arguments: controller
                                                          .movies[index],
                                                    );
                                                    if (updated != null &&
                                                        updated) {
                                                      _showCenterFlash(
                                                          alignment:
                                                              Alignment.center);
                                                    }
                                                  },
                                                  onTapDetails: () => action(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            offset: Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 50,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        ZoomDrawer.of(context)!.toggle();
                                      },
                                      child: CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/avatar.png'),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      child: AnimatedCrossFade(
                                        firstChild: Icon(Icons.search_rounded),
                                        secondChild: Icon(Icons.close),
                                        duration: Duration(milliseconds: 300),
                                        crossFadeState:
                                            !controller.expandedSearchBar
                                                ? CrossFadeState.showFirst
                                                : CrossFadeState.showSecond,
                                      ),
                                      onTap: () {
                                        //showOverlay(context);
                                        if (!controller.expandedSearchBar) {
                                          myFocusNode.requestFocus();
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          controller.clearSearch();
                                        }
                                        return controller
                                            .setExpandedSearchBar();
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    child: Observer(
                                      builder: (_) => AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        width: controller.expandedSearchBar
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .7
                                            : 0,
                                        height: 50,
                                        child: Container(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: "Digite sua pesquisa",
                                            ),
                                            focusNode: myFocusNode,
                                            controller:
                                                controller.searchEditController,
                                            onChanged: (value) =>
                                                controller.onSearch(value),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'home.movies_series'.tr(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Observer(
                                  builder: (context) => Text(
                                    controller.searchTerm.isEmpty
                                        ? '${controller.movies.length}'
                                        : '${controller.searchResult.length}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kMainColor,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              landscape: (context) => Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height * 0.65,
                      child: Observer(
                        builder: (context) => controller.searchTerm.isNotEmpty
                            ? controller.searchResult.isEmpty
                                ? Center(
                                    child: Text(
                                      "Nenhum item corresponde a busca.",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                : AnimationLimiter(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: controller.searchResult.length,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: 10,
                                      ),
                                      itemBuilder: (context, index) =>
                                          AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        child: SlideAnimation(
                                          horizontalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: CardMovieWidget(
                                              controller:
                                                  controller.slidableController,
                                              movie: controller
                                                  .searchResult[index],
                                              expanded: controller
                                                          .expandedItemIndex ==
                                                      index
                                                  ? true
                                                  : false,
                                              onTap: () =>
                                                  controller.expandItem(index),
                                              // onTap: () => _showCenterFlash(
                                              //     position: FlashPosition.top,
                                              //     style: FlashStyle.floating,
                                              //     movieName:
                                              //         controller.movies[index].title,
                                              //     note: controller.movies[index].note),
                                              onDismissed: (direction) {
                                                print(direction);
                                                if (direction ==
                                                    DismissDirection
                                                        .horizontal) {}
                                                controller.removeMovie(index);
                                              },
                                              onDelete: () =>
                                                  controller.removeMovie(index),
                                              onEdit: () {
                                                Modular.to.pushNamed(
                                                    '/home/add-movie');
                                              },
                                              onTapDetails: () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            : AnimationLimiter(
                                key: UniqueKey(),
                                child: ListView.separated(
                                  padding: EdgeInsets.only(bottom: 80, top: 15),
                                  shrinkWrap: true,
                                  itemCount: controller.movies.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: SlideAnimation(
                                        horizontalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: OpenContainer(
                                              // middleColor: Colors.red.withOpacity(.5),
                                              transitionType:
                                                  ContainerTransitionType
                                                      .fadeThrough,
                                              closedElevation: 0,
                                              closedShape:
                                                  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              transitionDuration:
                                                  Duration(milliseconds: 300),
                                              openBuilder: (context, action) =>
                                                  DetailsPage(
                                                movie: controller.movies[index],
                                              ),
                                              closedBuilder:
                                                  (context, action) => Observer(
                                                builder: (context) =>
                                                    CardMovieWidget(
                                                  controller: controller
                                                      .slidableController,
                                                  movie:
                                                      controller.movies[index],
                                                  expanded: controller
                                                              .expandedItemIndex ==
                                                          index
                                                      ? true
                                                      : false,
                                                  //onTap: () => action(),
                                                  onTap: () => controller
                                                      .expandItem(index),
                                                  // onTap: () => _showCenterFlash(
                                                  //     position: FlashPosition.top,
                                                  //     style: FlashStyle.floating,
                                                  //     movieName: controller.movies[index].title,
                                                  //     note: controller.movies[index].note),
                                                  onDismissed: (direction) {
                                                    print(direction);
                                                    if (direction ==
                                                        DismissDirection
                                                            .horizontal) {}
                                                    controller
                                                        .removeMovie(index);
                                                  },
                                                  onDelete: () {
                                                    return controller
                                                        .removeMovie(index);
                                                  },
                                                  onEdit: () async {
                                                    var updated = await Modular
                                                        .to
                                                        .pushNamed<bool>(
                                                      '/home/add-movie',
                                                      arguments: controller
                                                          .movies[index],
                                                    );
                                                    if (updated != null &&
                                                        updated) {
                                                      _showCenterFlash(
                                                          alignment:
                                                              Alignment.center);
                                                    }
                                                  },
                                                  onTapDetails: () => action(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            offset: Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 50,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        ZoomDrawer.of(context)!.toggle();
                                      },
                                      child: CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/avatar.png'),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      child: AnimatedCrossFade(
                                        firstChild: Icon(Icons.search_rounded),
                                        secondChild: Icon(Icons.close),
                                        duration: Duration(milliseconds: 300),
                                        crossFadeState:
                                            !controller.expandedSearchBar
                                                ? CrossFadeState.showFirst
                                                : CrossFadeState.showSecond,
                                      ),
                                      onTap: () {
                                        //showOverlay(context);
                                        if (!controller.expandedSearchBar) {
                                          myFocusNode.requestFocus();
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          controller.clearSearch();
                                        }
                                        return controller
                                            .setExpandedSearchBar();
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    child: Observer(
                                      builder: (_) => AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        width: controller.expandedSearchBar
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .7
                                            : 0,
                                        height: 50,
                                        child: Container(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: "Digite sua pesquisa",
                                            ),
                                            focusNode: myFocusNode,
                                            controller:
                                                controller.searchEditController,
                                            onChanged: (value) =>
                                                controller.onSearch(value),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Filmes e Series',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Observer(
                                  builder: (context) => Text(
                                    controller.searchTerm.isEmpty
                                        ? '${controller.movies.length}'
                                        : '${controller.searchResult.length}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kMainColor,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            transitionDuration: Duration(milliseconds: 500),
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            closedBuilder: (context, action) => GestureDetector(
              onTap: () => action(),
              child: Container(
                color: kMainColor,
                height: 60,
                width: 60,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            openBuilder: (context, action) => AddMoviePage(),
            tappable: false,
          ),
        ),
      ),
    );
  }

  void _showCenterFlash({
    FlashPosition? position,
    FlashStyle? style,
    Alignment? alignment,
  }) {
    showFlash(
      context: context,
      duration: Duration(seconds: 3),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Colors.blue,
          position: position,
          style: style,
          alignment: alignment,
          enableDrag: false,
          onTap: () => controller.dismiss(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Text(
                'Atualizado com Sucesso!',
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {}
    });
  }
}
