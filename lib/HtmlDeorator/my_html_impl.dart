import 'package:design_patterns/HtmlDeorator/my_html.dart';

class MyHtmlImpl extends MyHtml {
  MyHtmlImpl(String tags) {
    this.tags = tags;
  }

  @override
  String create() {
    return tags;
  }
}
