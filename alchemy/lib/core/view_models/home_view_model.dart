import 'dart:math';

import 'package:alchemy/core/models/efeitos.dart';
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

  List currentBackground = [0];
  Ingredientes currentIngredient;
  Efeitos currentEffect;

  int errorResponse = 0;

  int currentPositionOnAlphabetScroll = -1;
  String alphabetBubble = "";

  HomeViewModel() {
    getIngredients();
    getEffects();
    backgrounds = [
      [
        AssetImage("assets/bg/b1_1.jpg"),
        AssetImage("assets/bg/b1_2.jpg"),
        AssetImage("assets/bg/b1_3.jpg")
      ],
      [
        AssetImage("assets/bg/b2_1.jpg"),
        AssetImage("assets/bg/b2_2.jpg"),
        AssetImage("assets/bg/b2_3.jpg")
      ],
      [
        AssetImage("assets/bg/b3_1.jpg"),
        AssetImage("assets/bg/b3_2.jpg"),
        AssetImage("assets/bg/b3_3.jpg")
      ],
      [
        AssetImage("assets/bg/b4_1.jpg"),
        AssetImage("assets/bg/b4_2.jpg"),
        AssetImage("assets/bg/b4_3.jpg")
      ],
      [
        AssetImage("assets/bg/b5_1.jpg"),
        AssetImage("assets/bg/b5_2.jpg"),
        AssetImage("assets/bg/b5_3.jpg")
      ],
      [
        AssetImage("assets/bg/b6_1.jpg"),
        AssetImage("assets/bg/b6_2.jpg"),
        AssetImage("assets/bg/b6_3.jpg")
      ]
    ];
    chooseBackground();
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

  void updatePosition(int i) {
    currentPositionOnAlphabetScroll = i;
    notifyListeners();
  }

  void changeBubble(String b) {
    alphabetBubble = b;
    print("a " + b);
    notifyListeners();
  }
}
