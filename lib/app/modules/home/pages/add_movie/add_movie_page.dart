import 'package:animate_icons/animate_icons.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:to_do_list/app/adapters/movie.dart';
import 'package:to_do_list/app/modules/home/pages/add_movie/add_movie_controller.dart';
import 'package:to_do_list/app/modules/home/pages/add_movie/components/add_button_widget.dart';
import 'package:to_do_list/app/modules/home/pages/add_movie/components/add_text_field_widget.dart';
import 'package:to_do_list/app/shared/styles/colors.dart';

import 'components/dropdown_movie_type_widget.dart';

class AddMoviePage extends StatefulWidget {
  final Movie? movie;

  const AddMoviePage({Key? key, this.movie}) : super(key: key);
  @override
  AddMoviePageState createState() => AddMoviePageState();
}

class AddMoviePageState extends ModularState<AddMoviePage, AddMovieController> {
  String dropdownValue = '0';

  AnimateIconController iconController = AnimateIconController();

  @override
  void initState() {
    if (widget.movie != null) {
      controller.onEdit(widget.movie!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFEAEDF0),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: kMainColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Qual filme ou série gostaria de avaliar?',
                    style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Conta pra nós 🎥',
                    style: TextStyle(
                      color: kMainColor.withOpacity(.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 3,
                  width: double.maxFinite,
                  color: kMainColor.withOpacity(.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Observer(
                      builder: (_) => AddTextFieldWidget(
                        titleField: "Titulo",
                        controller: controller.titleController,
                        hintText: "Nome do Filme ou Série",
                        errorMessage: controller.validTitle,
                        onChanged: (value) => controller.setTitle(value),
                        errorTextOpacity: controller.validTitle.isEmpty ? 0 : 1,
                      ),
                    ),
                    SizedBox(height: 15),
                    Observer(
                      builder: (_) => AddTextFieldWidget(
                        titleField: "Nota",
                        controller: controller.noteController,
                        hintText: "Nota",
                        errorMessage: controller.validNote,
                        onChanged: (value) => controller.setNote(value),
                        errorTextOpacity: controller.validNote.isEmpty ? 0 : 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[0-9.]"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Observer(
                      builder: (context) => DropdownMovieWidget(
                        title: "Tipo",
                        values: ["Filmes", "Series"],
                        selectedItem: controller.selectedType.isEmpty
                            ? null
                            : controller.selectedType,
                        erroMessage: controller.validType,
                        onChanged: (value) =>
                            controller.setSelectedType(value ?? ''),
                      ),
                    ),
                    SizedBox(height: 15),
                    Observer(
                      builder: (context) => DropdownMovieWidget(
                        title: "Gênero",
                        maxHeight: 300,
                        values: [
                          "Drama",
                          "Ação",
                          "Romance",
                          "Comedia",
                          "Terror"
                        ],
                        selectedItem:
                            controller.genre.isEmpty ? null : controller.genre,
                        erroMessage: controller.validGenre,
                        onChanged: (value) => controller.setGenre(value ?? ''),
                      ),
                    ),
                    SizedBox(height: 15),
                    Observer(
                      builder: (_) => AddTextFieldWidget(
                        titleField: "Descrição",
                        controller: controller.descriptionController,
                        hintText: "Escreva um resumo",
                        errorMessage: controller.validDescription,
                        onChanged: (value) => controller.setDescription(value),
                        errorTextOpacity:
                            controller.validDescription.isEmpty ? 0 : 1,
                        countDigit: controller.description.length,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(200),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              AddButtonWidget(
                update: widget.movie == null ? false : true,
                onPressed: addOrUpdateMovie,
              ),
            ],
          ),
        ),
      ),
    );
  }

  addOrUpdateMovie() async {
    if (widget.movie != null) {
      if (controller.formIsValid) {
        bool updated = await controller.updateMovie(widget.movie!);

        if (updated)
          return Modular.to.pop(true);
        else
          return _showTopFlash(
            title: "Falha ao Atualizar",
            message: "Por favor, tente novamente.",
          );
      } else {
        _showTopFlash(
            title: "Verifique todos os campos",
            message: "Por favor, corrija todos os campos em vermelho.");
      }
    } else {
      controller.formIsValid ? controller.addMovie() : _showTopFlash();
    }
  }

  void _showTopFlash({String? title, String? message}) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          borderRadius: BorderRadius.circular(20),
          margin: EdgeInsets.all(5),
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          style: FlashStyle.floating,
          position: FlashPosition.top,
          child: Container(
            height: 100,
            color: Colors.red,
            child: Center(
              child: FlashBar(
                title: Text(
                  title ?? 'Preencha todos os campos',
                  style: TextStyle(color: Colors.white),
                ),
                message: Text(
                  message ?? 'Falta preencher algo',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
