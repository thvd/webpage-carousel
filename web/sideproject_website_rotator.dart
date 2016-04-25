import 'dart:html';
import 'dart:async';
import 'dart:collection';
import 'page-show.dart';
import 'dart:convert';

LinkedList<PageShow> arr = new LinkedList<PageShow>();
PageShow activeShow;

void main() {
  // get data from json file
  String configuration = _getConfiguration('web/data.json');
  if (configuration == null) {
    HttpRequest.getString('data.json').then(init);
  } else {
    init(configuration);
  }
}

/**
 * Init setup datastructures
 */
void init(String configurationStr) {
  Map<String, List<Map<String, dynamic>>> configurationMap =
      JSON.decode(configurationStr);

  for (Map<String, dynamic> pageShow in configurationMap['pageshows']) {
    var entry = new PageShow()
      ..duration = new Duration(seconds: pageShow['duration'])
      ..url = pageShow['url'];

    entry.element = (document.createElement('iframe') as IFrameElement)
      ..attributes['seamless'] = true.toString()
      ..style.display = 'none'
      ..src = entry.url;

    arr.add(entry);
  }

  Iterable<IFrameElement> iframes = arr.map((PageShow pShow) => pShow.element);

  document.body.children.addAll(iframes);

  _next();
}

/**
 * Show next PageShow object, and setup a Timer to display the following up PageShow object 
 */
void _next() {
  if (activeShow == null) {
    // first time, start
    activeShow = arr.first;

    activeShow.element.style.display = 'block';
    new Timer(activeShow.duration, _next);
  } else {
    // continue
    PageShow oldPage = activeShow;

    activeShow.element
      ..classes.addAll(['animated', 'bounceOutLeft'])
      ..on['animationend'].first.then((_) {
        // remove previous item

        // use cached `oldPage` variable, because there you are in an event
        // listener, and before the event is fired, the `activeShow`
        // variable will get another value.
        oldPage.element
          ..classes.removeAll(['animated', 'bounceOutLeft'])
          ..style.display = 'none';
      });

    // set next item
    activeShow = activeShow.next;

    // animate next item
    activeShow.element
      ..style.display = 'block'
      ..classes.addAll(['animated', 'bounceInRight'])
      ..on['animationend'].first.then((_) {
        activeShow.element.classes.removeAll(['animated', 'bounceInRight']);
        new Timer(activeShow.duration, _next);
      });
  }
}

String _getConfiguration(String path) {
  Element elem = querySelector('[type="json/data"][id="$path"]');
  if (elem == null) {
    return null;
  }
  return elem.text;
}
