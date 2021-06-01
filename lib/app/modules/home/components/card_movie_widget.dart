import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/app/adapters/movie.dart';
import 'package:to_do_list/app/shared/styles/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class CardMovieWidget extends StatefulWidget {
  final Function(DismissDirection direction) onDismissed;
  final Function() onTap;
  final Function() onTapDetails;
  final Function() onDelete;
  final Function() onEdit;
  final Movie movie;
  final bool expanded;
  final double? cardOffSet;
  final SlidableController controller;
  const CardMovieWidget({
    Key? key,
    required this.onDismissed,
    required this.onTap,
    required this.onTapDetails,
    required this.onDelete,
    required this.onEdit,
    required this.movie,
    required this.expanded,
    this.cardOffSet = 0,
    required this.controller,
  }) : super(key: key);

  @override
  _CardMovieWidgetState createState() => _CardMovieWidgetState();
}

class _CardMovieWidgetState extends State<CardMovieWidget>
    with SingleTickerProviderStateMixin {
  final int durationAnimation = 250;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );

  late final Animation<double> _animation;
  late final Animation<double> _animationOpacity;

  @override
  void initState() {
    _animation = Tween(begin: 1.0, end: 0.6).animate(_controller);
    _animationOpacity = Tween(begin: 1.0, end: 0.0).animate(_controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //widget.expanded ? _controller.forward() : _controller.reverse();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => AnimatedOpacity(
        opacity: _animationOpacity.value,
        duration: Duration(milliseconds: 100),
        child: Transform.scale(
          scale: _animation.value,
          child: GestureDetector(
            // onTap: widget.onTap,
            onTap: widget.onTap,
            child: IntrinsicHeight(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 90,
                  maxHeight: 300,
                ),
                child: Slidable(
                  controller: widget.controller,
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.black45,
                      icon: Icons.edit,
                      onTap: widget.onEdit,
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: widget.onDelete,
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 5,
                          decoration: BoxDecoration(
                            color: widget.movie.type.startsWith('F')
                                ? kMovieColor
                                : kSerieColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.movie.title} (${widget.movie.genre})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'home.note'.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${widget.movie.note}',
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              AnimatedContainer(
                                duration:
                                    Duration(milliseconds: durationAnimation),
                                height: widget.expanded ? 100 : 0,
                                child: AnimatedOpacity(
                                  duration:
                                      Duration(milliseconds: durationAnimation),
                                  opacity: widget.expanded ? 1 : 0,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      //mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'home.description'.tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${widget.movie.description}',
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: AnimatedContainer(
                                  duration:
                                      Duration(milliseconds: durationAnimation),
                                  height: widget.expanded ? 40 : 0,
                                  width: widget.expanded ? 240 : 0,
                                  color: kMainColor,
                                  child: TextButton(
                                    onPressed: () {
                                      widget.controller.activeState?.close();
                                      widget.onTapDetails();
                                    },
                                    child: Center(
                                      child: Text(
                                        'home.details'.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
