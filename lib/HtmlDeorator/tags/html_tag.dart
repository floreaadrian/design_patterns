import '../my_html.dart';
import '../my_tag.dart';

class HtmlTag extends MyTag {
  HtmlTag(MyHtml tag) : super(tag) {
    tags = 'html';
  }

  @override
  String create() {
    return '<$tags>\n${super.create()}\n</$tags>';
  }
}
