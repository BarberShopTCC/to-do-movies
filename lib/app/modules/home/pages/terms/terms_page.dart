import 'package:flutter/material.dart';
import 'package:to_do_list/app/shared/styles/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class TermsPage extends StatefulWidget {
  final String title;
  const TermsPage({Key? key, this.title = 'TermsPage'}) : super(key: key);
  @override
  TermsPageState createState() => TermsPageState();
}

class TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: kMainColor,
      ),
      body: Column(
        children: <Widget>[
          Text('terms_of_use.content').tr(),
        ],
      ),
    );
  }
}
