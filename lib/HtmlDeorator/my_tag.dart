import 'package:design_patterns/HtmlDeorator/my_html.dart';

abstract class MyTag extends MyHtml {
  final MyHtml html;

  MyTag(this.html);

  @override
  String create() {
    return html.create();
  }
}
