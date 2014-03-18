import 'package:angular/angular.dart';
import 'package:rss/dart_rss.dart';

main() {
  ngBootstrap(module: new FeedModule());
}

@NgController(
    selector: '[feed-list]',
    publishAs: 'FeedCtrl')
class FeedController {
  
  List<RssItem> feed;
  Http _http;
  
  FeedController(Http this._http) {
    
    _http.getString('http://www.corsproxy.com/feeds.nos.nl/nosjournaal?format=xml').then((data) {
//      print('data: $data');
      
      var rssParser = new RssParser(data);

      //..listen((d) { print('d: $d'); })
//      rssParser.onProcess()..toList().then((List<RssItem> _feed) {
//        print('_feed: $_feed');
//        feed = _feed;
//      });
      
      rssParser.onFinished.toList().then((List<RssItem> _feed) {
        print('_feed: $_feed');
        feed = _feed;
      });
//      rssParser.onProcess().listen((e) => print("listen: $e"));
      
//      rssParser.onFinished.listen((e) => print("listen: $e"), onDone: (a) {
//        print('done: $a');
//      });
      

    });
  }
  
}


class FeedModule extends Module {
  FeedModule() {
    type(FeedController);
  }
}
