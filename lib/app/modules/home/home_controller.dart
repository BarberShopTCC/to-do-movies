import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:to_do_list/app/adapters/movie.dart';
import 'package:to_do_list/app/interfaces/local_storage_service_interface.dart';
import 'package:to_do_list/app/shared/styles/texts.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  final ILocalStorageService _storageService;

  HomeControllerBase(this._storageService);

  @observable
  ObservableList<Movie> movies = <Movie>[].asObservable();

  @observable
  ObservableList<Movie> searchResult = <Movie>[].asObservable();

  @action
  removeMovie(int index) {
    _storageService.delete(movies[index]);
    movies.removeAt(index);
  }

  @action
  loadMovies() {
    var moviesList = _storageService.getAll().then((value) => value.fold((l) {
          return null;
        }, (r) {
          return movies = r.asObservable();
        }));
  }

  @observable
  bool expandedSearchBar = false;
  @action
  setExpandedSearchBar() => expandedSearchBar = !expandedSearchBar;

  @observable
  String searchTerm = '';

  @action
  onSearch(String search) {
    searchTerm = search;
    List<Movie> tempList = [];
    movies.forEach((element) {
      if (element.title.toUpperCase().startsWith(search.toUpperCase())) {
        tempList.add(element);
      }
    });
    searchResult = tempList.asObservable();
  }

  @observable
  TextEditingController searchEditController = TextEditingController();

  @action
  clearSearch() {
    searchEditController.clear();
    searchTerm = '';
  }

  @observable
  int expandedItemIndex = -1;
  @action
  expandItem(int index) {
    if (expandedItemIndex == index) {
      return expandedItemIndex = -1;
    } else {
      return expandedItemIndex = index;
    }
  }

  @observable
  ZoomDrawerController drawerController = ZoomDrawerController();

  @observable
  SlidableController slidableController = SlidableController();

  @action
  massInsert() async {
    var movies = await Hive.openBox<Movie>('movies');
    final filme1 = Movie(
      title: "Tronn",
      type: 'Filme',
      note: 10,
      description: kLoremIpsum,
      genre: "Comedia",
    );
    final filme2 = Movie(
      title: "Pelo Horario da Manhã",
      type: 'Serie',
      note: 0,
      description: kLoremIpsum,
      genre: "Comedia",
    );
    final filme3 = Movie(
      title: "Os Cabras da peste",
      type: 'Serie',
      note: 9.9,
      description: kLoremIpsum,
      genre: "Comedia",
    );
    final filme4 = Movie(
      title: "Avatar",
      type: 'Filme',
      note: 8,
      description: kLoremIpsum,
      genre: "Comedia",
    );
    final filme5 = Movie(
      title: "Homens de Honra",
      type: 'Filme',
      note: 10,
      description: kLoremIpsum,
      genre: "Comedia",
    );
    final filme6 = Movie(
      title: "Chicago PD",
      type: 'Serie',
      note: 8,
      description: kLoremIpsum,
      genre: "Comedia",
    );

    //movies.addAll([filme1, filme2, filme3, filme4, filme5, filme6]);
  }
}
