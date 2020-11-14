import '../my_html.dart';
import '../my_tag.dart';

class BTag extends MyTag {
  BTag(MyHtml tag) : super(tag) {
    tags = 'b';
  }

  @override
  String create() {
    return '<$tags>\n${super.create()}\n</$tags>';
  }
}
