import 'package:design_patterns/HtmlDeorator/my_html.dart';
import 'package:design_patterns/HtmlDeorator/my_tag.dart';

class OlTag extends MyTag {
  OlTag(MyHtml tag) : super(tag) {
    tags = 'ol';
  }

  @override
  String create() {
    return '<$tags>\n${super.create()}\n</$tags>';
  }
}
