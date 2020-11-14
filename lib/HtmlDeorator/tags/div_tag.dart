import '../my_html.dart';
import '../my_tag.dart';

class DivTag extends MyTag {
  DivTag(MyHtml tag) : super(tag) {
    tags = 'div';
  }

  @override
  String create() {
    return '<$tags>\n${super.create()}\n</$tags>';
  }
}
