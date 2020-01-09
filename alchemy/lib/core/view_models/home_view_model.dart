import 'dart:math';

import 'package:alchemy/core/models/efeitos.dart';
import 'package:alchemy/core/models/infoE.dart';
import 'package:alchemy/core/models/infoI.dart';
import 'package:alchemy/core/models/ingredientes.dart';
import 'package:alchemy/core/services/custom_api.dart';
import 'package:alchemy/core/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends BaseViewModel {
  CustomAPI api = CustomAPI();
  static HomeViewModel homeViewModel;
  static HomeViewModel instance() {
    if (homeViewModel == null) {
      homeViewModel = HomeViewModel();
    }
    return homeViewModel;
  }

  List backgrounds = List();
  List<Ingredientes> ingredientes = List();
  List<Efeitos> efeitos = List();
  IngredienteInfo currentIInfo;
  EfeitoInfo currentEInfo;
  List<String> schools = List();

  List currentBackground = [0];
  Ingredientes currentIngredient;
  Efeitos currentEffect;

  int errorResponse = 0;

  int currentPositionOnAlphabetScroll = -1;
  int currentPositionOnAlphabetScroll2 = -1;

  String alphabetBubble = "";

  bool mostrarBackground;
  bool mostrarLocations;

  int screensOpen = 0;

  int currentTabBar;

  HomeViewModel() {
    mostrarBackground = false;
    mostrarLocations = false;
    getIngredients();
    getEffects();
    currentTabBar = 1;

    backgrounds = [
      [
        AssetImage("assets/bg/b1_1.jpg"),
        AssetImage("assets/bg/b1_2.jpg"),
        AssetImage("assets/bg/b1_3.jpg"),
        "assets/bg/background1.jpg"
      ],
      [
        AssetImage("assets/bg/b2_1.jpg"),
        AssetImage("assets/bg/b2_2.jpg"),
        AssetImage("assets/bg/b2_3.jpg"),
        "assets/bg/background2.jpg"
      ],
      [
        AssetImage("assets/bg/b3_1.jpg"),
        AssetImage("assets/bg/b3_2.jpg"),
        AssetImage("assets/bg/b3_3.jpg"),
        "assets/bg/background3.jpg"
      ],
      [
        AssetImage("assets/bg/b4_1.jpg"),
        AssetImage("assets/bg/b4_2.jpg"),
        AssetImage("assets/bg/b4_3.jpg"),
        "assets/bg/background4.jpg"
      ],
      [
        AssetImage("assets/bg/b5_1.jpg"),
        AssetImage("assets/bg/b5_2.jpg"),
        AssetImage("assets/bg/b5_3.jpg"),
        "assets/bg/background5.jpg"
      ],
      [
        AssetImage("assets/bg/b6_1.jpg"),
        AssetImage("assets/bg/b6_2.jpg"),
        AssetImage("assets/bg/b6_3.jpg"),
        "assets/bg/background6.jpg"
      ]
    ];
    chooseBackground();

    schools = [
      "All",
      "Alteration",
      "Destruction",
      "Illusion",
      "Restoration",
    ];
  }

  void getIngredients() async {
    try {
      var response = await api.getIngredientsFromJson();
      if (response is List<Ingredientes>) {
        ingredientes = response;
      } else if (response is int) {
        errorResponse = -1;
      }
    } catch (e) {
      errorResponse = -1;
      throw e;
    }
    notifyListeners();
  }

  void getEffects() async {
    try {
      var response = await api.getEffectsFromJson();
      if (response is List<Efeitos>) {
        efeitos = response;
      } else if (response is int) {
        errorResponse = -1;
      }
    } catch (e) {
      errorResponse = -1;
      throw e;
    }
    notifyListeners();
  }

  void nulifyCurrentInfo() {
    currentIInfo = null;
    notifyListeners();
  }

  void nulifyCurrentInfo2() {
    currentEInfo = null;
    notifyListeners();
  }

  void getInfoI(String url) async {
    try {
      var response = await api.getURLFromJson(url);
      if (response is IngredienteInfo) {
        currentIInfo = response;
        errorResponse = 0;
      } else if (response is int) {
        errorResponse = -1;
      }
    } catch (e) {
      errorResponse = -1;
      throw e;
    }
    notifyListeners();
  }

  void getInfoE(String url) async {
    try {
      var response = await api.getURL2FromJson(url);
      if (response is EfeitoInfo) {
        currentEInfo = response;
        errorResponse = 0;
      } else if (response is int) {
        errorResponse = -1;
      }
    } catch (e) {
      errorResponse = -1;
      throw e;
    }
    notifyListeners();
  }

  void chooseBackground() {
    var chosen = new Random();
    int c = 1 + chosen.nextInt(6);
    currentBackground[0] = backgrounds[c - 1];
  }

  void refresh() {
    errorResponse = 0;
    getIngredients();
    notifyListeners();
  }

  void changeItem(Ingredientes item) {
    currentIngredient = item;
    notifyListeners();
  }

  void changeItem2(Efeitos item) {
    currentEffect = item;
    notifyListeners();
  }

  void changeItem3(String title) {
    for (var item in efeitos) {
      if (item.title == title) {
        currentEffect = item;
        notifyListeners();
        break;
      }
    }
  }

  void changeItem4(String title) {
    for (var item in ingredientes) {
      if (item.title == title) {
        currentIngredient = item;
        notifyListeners();
        break;
      }
    }
  }

  void updatePosition(int i) {
    currentPositionOnAlphabetScroll = i;
    notifyListeners();
  }

  void updatePosition2(int i) {
    currentPositionOnAlphabetScroll2 = i;
    notifyListeners();
  }

  void changeBubble(String b) {
    alphabetBubble = b;
    notifyListeners();
  }

  int returnLi(int index) {
    for (var i = 0; i < currentIInfo.innerLocations.indexes.length; i++) {
      if (currentIInfo.innerLocations.indexes[i] == index) {
        return i;
      }
    }
  }

  void changeMostrarBackground() {
    mostrarBackground = !mostrarBackground;
    notifyListeners();
  }

  void changeMostrarLocations() {
    mostrarLocations = !mostrarLocations;
    notifyListeners();
  }

  void fecharInfos() {
    mostrarLocations = false;
    mostrarBackground = false;
    notifyListeners();
  }

  void changeTab(int tab) {
    currentTabBar = tab;
    notifyListeners();
  }

  List<String> returnURL(String url) {
    String aux;
    String aux2;
    int aux3 = 0;
    for (var i = 0; i < url.length; i++) {
      if (url[i] + url[i + 1] == "i/") {
        aux = url.substring(i + 2);
        for (var j = 0; j < aux.length; j++) {
          if (aux[j] == "_") {
            aux3 = aux3 + 1;
          }
          if (aux[j] == "%") {
            aux3 = aux3 + 2;
          }
        }
        aux2 = aux
            .substring(0, (aux.length + aux3) ~/ 2)
            .replaceAll("_", " ")
            .replaceAll("%27", "'");
        aux = url.substring(0, 6) + aux.substring(0, (aux.length + aux3) ~/ 2);
        return [aux, aux2];
      }
    }
  }

  String getEfeitoImage(String nomeEfeito) {
    for (var item in efeitos) {
      if (nomeEfeito == "Paralyze" && item.title == "Paralysis") {
        return item.icon;
      }
      if (item.title == nomeEfeito) {
        return item.icon;
      }
    }
  }

  List<AryEffect> getIngredientsEffects() {
    List<AryEffect> temp = List<AryEffect>();
    temp.add(currentIngredient.primaryEffect);
    temp.add(currentIngredient.secondaryEffect);
    temp.add(currentIngredient.tertiaryEffect);
    temp.add(currentIngredient.quaternaryEffect);
    return temp;
  }

  bool isLetter(String letter, String tab) {
    if (tab == "ingrediente") {
      for (var i = 0; i < ingredientes.length; i++) {
        if (ingredientes[i].title[0] == letter) {
          return true;
        }
      }
      return false;
    } else if (tab == "efeito") {
      for (var i = 0; i < efeitos.length; i++) {
        if (efeitos[i].title[0] == letter) {
          return true;
        }
      }
      return false;
    }
  }

  void getPosition(int index, String tab, ScrollController c) {
    if (tab == "ingrediente") {
      if (index > 21 && String.fromCharCode(65 + index) == "Y") {
        c.jumpTo(c.position.maxScrollExtent);
        updatePosition(index);
        changeBubble(String.fromCharCode(65 + index));
      } else {
        for (var i = 0; i < ingredientes.length; i++) {
          if (ingredientes[i].title[0] == String.fromCharCode(65 + index)) {
            c.jumpTo((i ~/ 2).toDouble() * 219.5);
            updatePosition(index);
            changeBubble(String.fromCharCode(65 + index));
            break;
          }
        }
      }
    } else if (tab == "efeito") {
      if (index > 20 && String.fromCharCode(65 + index) == "W") {
        c.jumpTo((48 ~/ 2).toDouble() * 219.5);
        updatePosition2(index);
        changeBubble(String.fromCharCode(65 + index));
      } else {
        for (var i = 0; i < efeitos.length; i++) {
          if (efeitos[i].title[0] == String.fromCharCode(65 + index)) {
            c.jumpTo((i ~/ 2).toDouble() * 219.5);
            updatePosition2(index);
            changeBubble(String.fromCharCode(65 + index));
            break;
          }
        }
      }
    }
  }
}
