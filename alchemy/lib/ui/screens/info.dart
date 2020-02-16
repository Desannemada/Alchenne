import 'package:alchemy/ui/widgets/webview.dart';
import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;

class InfoScreen extends StatelessWidget {
  final List<String> urls = [
    '<a href="https://elderscrolls.fandom.com/wiki/Ingredients_(Skyrim)">Skyrim - The Elder Scrolls Wiki - Fandom</a>',
    '<a href="https://en.uesp.net/wiki/Skyrim:Alchemy_Effects">The Unofficial Elder Scrolls Pages (UESP)</a>',
    '<a href="https://skyrim.gamepedia.com/Category:Ingredient_images">Skyrim Wiki - Gamepedia</a>',
    '<a href="https://wall.alphacoders.com/big.php?i=199646">Wallpaper1</a> by <a href="https://alphacoders.com/users/profile/40898">Shakala</a>',
    '<a href="https://www.wallpaperup.com/132937/Skyrim_Elder_Scrolls_Landscape_Mountains_Lake.html#post-1576">Wallpaper2</a> by <a href="https://www.wallpaperup.com/member/profile/1115">BelleDeesse</a>',
    '<a href="https://wallpapersafari.com/w/3L9dYg">Wallpaper3</a> found on <a href="https://wallpapersafari.com/">Wallpaper Safari</a>',
    '<a href="https://wallpapersafari.com/w/Ih8vNM">Wallpaper4</a> found on <a href="https://wallpapersafari.com/">Wallpaper Safari</a>',
    '<a href="https://wallpapersafari.com/w/chEAzt">Wallpaper5</a> found on <a href="https://wallpapersafari.com/">Wallpaper Safari</a>',
  ];
  final List<String> titles = [
    "The Elder Scrolls Fandom Wiki",
    "The Unofficial Elder Scrolls Pages (UESP)",
    "Skyrim Wiki - Gamepedia",
    "Wallpaper1 - Shakala",
    "Wallpaper2 - BelleDeesse",
    "Wallpaper3 - Wallpaper Safari",
    "Wallpaper4 - Wallpaper Safari",
    "Wallpaper5 - Wallpaper Safari",
  ];
  final List<String> contentsBy = [
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
          style: TextStyle(color: Theme.of(context).textTheme.body1.color),
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
              shrinkWrap: true,
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: index < 3
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
                      color: Theme.of(context).textTheme.body1.color,
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
