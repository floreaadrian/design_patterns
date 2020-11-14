import 'package:design_patterns/HtmlDeorator/my_html.dart';
import 'package:design_patterns/HtmlDeorator/my_tag.dart';

class PTag extends MyTag {
  PTag(MyHtml tag) : super(tag) {
    tags = 'p';
  }

  @override
  String create() {
    return '<$tags>\n${super.create()}\n</$tags>';
  }
}
