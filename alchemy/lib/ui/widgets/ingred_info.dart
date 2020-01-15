import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/values/strings.dart';
import 'package:alchemy/ui/widgets/effect_info.dart';
import 'package:alchemy/ui/widgets/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:html2md/html2md.dart' as html2md;

class IngredientInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    if (homeViewModel.errorResponse == -1) {
      Future.delayed(Duration(seconds: 5), () {
        showDialog(
            context: context,
            builder: (BuildContext bc) => AlertDialog(
                  elevation: 10,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Erro de Conexão >.<",
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        child: Text("Refresh"),
                        onPressed: () {
                          homeViewModel.getInfoI(INGREDIENT_URL +
                              homeViewModel.currentIngredient.url);
                          Navigator.of(bc).pop();
                        },
                      ),
                    ],
                  ),
                ));
      });
    }

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
          homeViewModel.currentIngredient.title,
          style: TextStyle(color: Theme.of(context).textTheme.body1.color),
        ),
      ),
      body: homeViewModel.currentIInfo == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).textTheme.body1.color,
                ),
              ),
            )
          : ListView(
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
                              "assets/ingredients/${homeViewModel.currentIngredient.title.replaceAll(" ", "")}.png",
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
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
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
                                        fontSize: 16 /
                                            MediaQuery.of(context)
                                                .textScaleFactor,
                                        color: Theme.of(context)
                                            .textTheme
                                            .body1
                                            .color),
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
                            onPressed: () {
                              // Navigator.of(context).pop();
                              homeViewModel.changeItem3(homeViewModel
                                  .getIngredientsEffects()[index]
                                  .title);
                              homeViewModel.nulifyCurrentInfo2();
                              homeViewModel.getInfoE(
                                  EFEITO_URL + homeViewModel.currentEffect.url);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EffectInfo()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(
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
                                  child: FlatButton(
                                    onPressed: () =>
                                        homeViewModel.changeMostrarBackground(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Background",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 21,
                                            color: Theme.of(context)
                                                .textTheme
                                                .body1
                                                .color,
                                          ),
                                        ),
                                        Icon(
                                          homeViewModel.mostrarBackground
                                              ? Icons.keyboard_arrow_down
                                              : Icons.keyboard_arrow_left,
                                          color: Theme.of(context)
                                              .textTheme
                                              .body1
                                              .color,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: homeViewModel.mostrarBackground
                                      ? Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: InfoTexts(
                                              info: homeViewModel
                                                  .currentIInfo.background),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: FlatButton(
                          onPressed: () =>
                              homeViewModel.changeMostrarLocations(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Locations",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 21,
                                  color:
                                      Theme.of(context).textTheme.body1.color,
                                ),
                              ),
                              Icon(
                                homeViewModel.mostrarLocations
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_left,
                                color: Theme.of(context).textTheme.body1.color,
                              )
                            ],
                          ),
                        ),
                      ),
                      homeViewModel.currentIInfo.titleLocation == ""
                          ? Container()
                          : Container(
                              child: homeViewModel.mostrarLocations
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: InfoTexts(
                                          info: homeViewModel
                                              .currentIInfo.titleLocation),
                                    )
                                  : Container(),
                            ),
                      homeViewModel.currentIInfo.locations.isEmpty
                          ? Container()
                          : homeViewModel.mostrarLocations
                              ? ListView.separated(
                                  separatorBuilder:
                                      (BuildContext bc, int index) =>
                                          SizedBox(height: 10),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  shrinkWrap: true,
                                  itemCount: homeViewModel
                                      .currentIInfo.locations.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext bc, int index) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("▫ "),
                                            Expanded(
                                              child: InfoTexts(
                                                  info: homeViewModel
                                                      .currentIInfo
                                                      .locations[index]),
                                            ),
                                          ],
                                        ),
                                        homeViewModel.currentIInfo
                                                .innerLocations.indexes.isEmpty
                                            ? Container()
                                            : homeViewModel.currentIInfo
                                                    .innerLocations.indexes
                                                    .contains(index)
                                                ? ListView.separated(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    shrinkWrap: true,
                                                    separatorBuilder:
                                                        (BuildContext bc,
                                                                int i) =>
                                                            SizedBox(height: 5),
                                                    itemCount: homeViewModel
                                                        .currentIInfo
                                                        .innerLocations
                                                        .inners[homeViewModel
                                                            .returnLi(index)]
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext bc,
                                                                int i) =>
                                                            Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1),
                                                          child: Text("▫ "),
                                                        ),
                                                        Expanded(
                                                          child: InfoTexts(
                                                            info: homeViewModel
                                                                    .currentIInfo
                                                                    .innerLocations
                                                                    .inners[
                                                                homeViewModel
                                                                    .returnLi(
                                                                        index)][i],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container()
                                      ],
                                    );
                                  },
                                )
                              : Container(),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class InfoTexts extends StatelessWidget {
  const InfoTexts({
    Key key,
    @required this.info,
  }) : super(key: key);

  final String info;

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return MarkdownBody(
      shrinkWrap: true,
      data: html2md.convert(info),
      onTapLink: (String url) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => MyWebView(
              title: homeViewModel.returnURL(url)[1],
              selectedUrl: INGREDIENT_URL + homeViewModel.returnURL(url)[0],
            ),
          ),
        );
      },
      styleSheet: MarkdownStyleSheet(
        textAlign: WrapAlignment.spaceBetween,
        a: TextStyle(
          color: Colors.blue,
          fontSize: 18,
        ),
        p: TextStyle(
          color: Theme.of(context).textTheme.body1.color,
          fontSize: 18,
        ),
      ),
    );
  }
}
