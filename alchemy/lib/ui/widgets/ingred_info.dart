import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:url_launcher/url_launcher.dart';

class IngredientInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          homeViewModel.currentIngredient.title,
          style: TextStyle(color: Theme.of(context).textTheme.body1.color),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).textTheme.body1.color),
                    ),
                    child: Image.asset(
                      homeViewModel.currentBackground[0][3],
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).textTheme.body1.color),
                      borderRadius: BorderRadius.all(Radius.circular(80)),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.7),
                      child: Image.asset(
                        "assets/ingredients/${homeViewModel.currentIngredient.title}.png",
                        fit: BoxFit.contain,
                        scale: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 3,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
              4,
              (int index) => Stack(
                children: <Widget>[
                  Card(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black38),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          homeViewModel.getEfeitoImage(homeViewModel
                              .getIngredientsEffects()[index]
                              .title),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              homeViewModel
                                  .getIngredientsEffects()[index]
                                  .title,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: homeViewModel.currentIInfo == null
                ? Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).textTheme.body1.color,
                        ),
                      ),
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      homeViewModel.currentIInfo.background == ""
                          ? Container()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Background:",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 21),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: MarkdownBody(
                                    shrinkWrap: true,
                                    data: html2md.convert(
                                        homeViewModel.currentIInfo.background),
                                    styleSheet: MarkdownStyleSheet(
                                      textAlign: WrapAlignment.spaceBetween,
                                      a: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                      ),
                                      p: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .body1
                                            .color,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Locations:",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21),
                        ),
                      ),
                      homeViewModel.currentIInfo.titleLocation == ""
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: MarkdownBody(
                                shrinkWrap: true,
                                data: html2md.convert(
                                    homeViewModel.currentIInfo.titleLocation),
                                styleSheet: MarkdownStyleSheet(
                                  textAlign: WrapAlignment.spaceBetween,
                                  a: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                  ),
                                  p: TextStyle(
                                    color:
                                        Theme.of(context).textTheme.body1.color,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                      homeViewModel.currentIInfo.locations.isEmpty
                          ? Container()
                          : ListView.separated(
                              separatorBuilder: (BuildContext bc, int index) =>
                                  SizedBox(height: 10),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shrinkWrap: true,
                              itemCount:
                                  homeViewModel.currentIInfo.locations.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext bc, int index) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("▫ "),
                                    Expanded(
                                      child: MarkdownBody(
                                        shrinkWrap: true,
                                        // onTapLink: (String url) {
                                        //   print(INGREDIENT_URL + url);
                                        //   launch(INGREDIENT_URL + url);
                                        // },
                                        data: html2md.convert(
                                          homeViewModel
                                              .currentIInfo.locations[index],
                                        ),
                                        styleSheet: MarkdownStyleSheet(
                                          textAlign: WrapAlignment.spaceBetween,
                                          a: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18,
                                          ),
                                          p: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .body1
                                                .color,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
