import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:to_do_list/app/adapters/movie.dart';
import 'package:to_do_list/app/interfaces/local_storage_service_interface.dart';
import 'package:to_do_list/app/modules/home/home_controller.dart';

part 'add_movie_controller.g.dart';

class AddMovieController = _AddMovieControllerBase with _$AddMovieController;

abstract class _AddMovieControllerBase with Store {
  final ILocalStorageService _storageService;

  _AddMovieControllerBase(this._storageService);

  final _homeController = Modular.get<HomeController>();

  //Text Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @observable
  String title = '';
  @observable
  double note = -1;
  @observable
  String selectedType = '';
  @observable
  String genre = '';
  @observable
  String description = '';

  @action
  setTitle(String v) => title = v;
  @action
  setNote(String v) => note = v.isNotEmpty ? double.parse(v) : -1;
  @action
  setSelectedType(String type) => selectedType = type;
  @action
  setGenre(String v) => genre = v;
  @action
  setDescription(String v) => description = v;

  @computed
  String get validTitle => title.isEmpty ? 'Campo Obrigatorio' : '';

  @computed
  String get validNote {
    if (note >= 0 && note <= 10) {
      return '';
    } else if (note > 10) {
      return 'Insira um valor de 0 à 10';
    } else {
      return 'Campo Obrigatorio';
    }
  }

  @computed
  String get validType => selectedType.isEmpty ? 'Selecione uma opção' : '';

  @computed
  String get validGenre => genre.isEmpty ? 'Selecione uma opção' : '';

  @computed
  String get validDescription => description.isEmpty ? 'Campo Obrigatorio' : '';

  @computed
  bool get formIsValid {
    if (validTitle.isEmpty &&
        validNote.isEmpty &&
        validType.isEmpty &&
        validDescription.isEmpty &&
        validGenre.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  addMovie() {
    Movie movie = Movie(
      title: title,
      type: selectedType,
      genre: genre,
      note: note,
      description: description,
    );
    _storageService.insert(movie);
    _homeController.movies.add(movie);
    Modular.to.pop();
  }

  Future<bool> updateMovie(Movie movie) async {
    var movieEdited = movie
      ..title = title
      ..type = selectedType
      ..genre = genre
      ..note = note
      ..description = description;

    var data = await _storageService.put(movieEdited);

    if (data.isRight())
      return true;
    else
      return false;
  }

  @observable
  bool dropDownTypeExpanded = false;
  @action
  expandDropDownType() => dropDownTypeExpanded = !dropDownTypeExpanded;

  onEdit(Movie movie) {
    title = movie.title;
    note = movie.note;
    selectedType = movie.type;
    genre = movie.genre;
    description = movie.description;

    titleController.text = movie.title;
    noteController.text = movie.note.toString();
    descriptionController.text = movie.description;
  }
}
