import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/app/adapters/movie.dart';
import 'package:to_do_list/app/shared/styles/colors.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class DetailsPage extends StatefulWidget {
  final Movie movie;

  const DetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEDF0),
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Modular.to.pushNamed<bool>(
                '/home/add-movie',
                arguments: widget.movie,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Tipo:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(widget.movie.type),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Genero:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(widget.movie.genre),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Nota:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(widget.movie.note.toString()),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Text(
                        'Criado em:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        DateFormat("dd-MM-yyyy 'as' H:m")
                            .format(widget.movie.createdAt),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Descrição:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.movie.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
