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
  Map<String, List<Map<String, dynamic>>> configurationMap = JSON.decode(configurationStr);
  
  configurationMap['pageshows'].forEach((Map<String, dynamic> pageShow) {
    arr.add(new PageShow()
      ..duration = new Duration(seconds: pageShow['duration'])
      ..url = pageShow['url']);
  });
 
  arr.forEach((PageShow pShow) {
    pShow.element = (document.createElement('iframe') as IFrameElement)
      ..attributes['seamless'] = true.toString()
      ..style.display = 'none'
      ..src = pShow.url;
    
    document.body.children.add(pShow.element);
  });
  
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
    activeShow.element
      ..classes.addAll(['animated', 'bounceOutLeft'])
      ..on['animationend'].first.then((e) {
        // remove previous item
        activeShow.element
          ..classes.removeAll(['animated', 'bounceOutLeft'])
          ..style.display = 'none';

        // set next item
        activeShow = activeShow.next;

        // animate next item
        activeShow.element
          ..style.display = 'block'
          ..classes.addAll(['animated', 'bounceInRight'])
          ..on['animationend'].first.then((e) {
            activeShow.element.classes.removeAll(['animated', 'bounceInRight']);
            new Timer(activeShow.duration, _next);
          });
      });
  }
}

/**
 * Load an URL in an iframe
 */
_setUrl(IFrameElement _iframe, String url) {
  try {
    _iframe.src = url;
  } catch (e) {
    print('******error-');
    print(e);
    print('-error******');
  }
}

String _getConfiguration(String path) {
  Element elem = querySelector('[type="json/data"][id="$path"]');
  if (elem == null) {
    return null;
  }
  return elem.text;
}
