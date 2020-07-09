import 'package:alchemy/ui/widgets/webview.dart';
import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;

class InfoScreen extends StatelessWidget {
  final List<String> urls = [
    '<a href="https://thumbs.gfycat.com/DetailedJauntyCur-mobile.mp4">Diogo Correia</a>',
    '<a href="https://elderscrolls.fandom.com/wiki/Ingredients_(Skyrim)">Skyrim - The Elder Scrolls Wiki - Fandom</a>',
    '<a href="https://en.uesp.net/wiki/Skyrim:Alchemy_Effects">The Unofficial Elder Scrolls Pages (UESP)</a>',
    '<a href="https://skyrim.gamepedia.com/Category:Ingredient_images">Skyrim Wiki - Gamepedia</a>',
    '<a href="https://www.flickr.com/photos/106746736@N06/31136037851">Wallpaper1</a> by <a href="https://www.flickr.com/photos/106746736@N06/">D U B L</a>',
    '<a href="https://www.flickr.com/photos/106746736@N06/30350009903">Wallpaper2</a> by <a href="https://www.flickr.com/photos/106746736@N06/">D U B L</a>',
    '<a href="https://www.allwallpaper.in/the-elder-scrolls-v-skyrim-landscapes-multiscreen-panorama-wallpaper-15110.html">Wallpaper3</a> found on <a href="https://www.allwallpaper.in/">All Wallpaper</a>',
    '<a href="https://wallpapersafari.com/w/RLsk0M">Wallpaper4</a> found on <a href="https://wallpapersafari.com/">Wallpaper Safari</a>',
    '<a href="https://www.flickr.com/photos/106746736@N06/31561425935">Wallpaper5</a> by <a href="https://www.flickr.com/photos/106746736@N06/">D U B L</a>',
  ];
  final List<String> titles = [
    "Diogo Correia",
    "The Elder Scrolls Fandom Wiki",
    "The Unofficial Elder Scrolls Pages (UESP)",
    "Skyrim Wiki - Gamepedia",
    "Wallpaper1 - D U B L",
    "Wallpaper2 - D U B L",
    "Wallpaper3 - All Wallpaper",
    "Wallpaper4 - Wallpaper Safari",
    "Wallpaper5 - D U B L",
  ];
  final List<String> contentsBy = [
    "logo by:\n",
    "ingredient's info by:\n",
    "effect's info and images by:\n",
    "ingredient's images by:\n",
    "wallpapers:\n",
    "",
    "",
    "",
    "",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "About",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 30),
            child: Text(
              "Developed by",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width *
                    0.0485 /
                    MediaQuery.of(context).textScaleFactor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: Text(
              "Desannemada\n/\\_/\\\n( o.o )\n> ^ <",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width *
                    0.0485 /
                    MediaQuery.of(context).textScaleFactor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Alchenne is Powered by",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width *
                    0.0485 /
                    MediaQuery.of(context).textScaleFactor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: index < 4
                    ? EdgeInsets.all(10)
                    : EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: MarkdownBody(
                  shrinkWrap: true,
                  data: contentsBy[index] + html2md.convert(urls[index]),
                  onTapLink: (String url) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyWebView(
                          title: titles[index],
                          selectedUrl: url,
                        ),
                      ),
                    );
                  },
                  styleSheet: MarkdownStyleSheet(
                    textAlign: WrapAlignment.center,
                    a: TextStyle(
                      color: Colors.blue,
                      fontSize: MediaQuery.of(context).size.width *
                          0.0485 /
                          MediaQuery.of(context).textScaleFactor,
                    ),
                    p: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
