from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
from bs4 import BeautifulSoup
import requests
import re

# Configurando servidor
app = Flask("alchemy")
cors = CORS(app)
app.config["CORS_HEADERS"] = "Content-Type"

baseURL = "https://elderscrolls.fandom.com"
baseURL2 = "https://en.uesp.net"


@cross_origin()
@app.route("/ingredientes")
def getIngredientes():
    dog = BeautifulSoup(requests.get(
        f"{baseURL}/wiki/Ingredients_(Skyrim)").content, "html5lib")
    dogTable = dog.find("table", attrs={"id": "ingredientsTable", })
    tbody = dogTable.find("tbody")
    dogTable = tbody.findAll("tr")

    listaRetorno = []

    for i in range(1, len(dogTable)):
        listaDogis = dogTable[i].findAll("td")

        listaRetorno.append({
            "title": listaDogis[0].a["title"].replace(" (Skyrim)", "").replace(" (Dragonborn)", ""),
            "primaryEffect": {"title": listaDogis[1].a["title"].replace(" (Skyrim)", "").replace(" Skill", "").replace("-h", "-H").replace("Archery", "Marksman"), "url": listaDogis[1].a["href"]},
            "secondaryEffect": {"title": listaDogis[2].a["title"].replace(" (Skyrim)", "").replace(" Skill", "").replace("-h", "-H").replace("Archery", "Marksman"), "url": listaDogis[1].a["href"]},
            "tertiaryEffect": {"title": listaDogis[3].a["title"].replace(" (Skyrim)", "").replace(" Skill", "").replace("-h", "-H").replace("Archery", "Marksman"), "url": listaDogis[1].a["href"]},
            "quaternaryEffect": {"title": listaDogis[4].a["title"].replace(" (Skyrim)", "").replace(" Skill", "").replace("-h", "-H").replace("Archery", "Marksman"), "url": listaDogis[1].a["href"]},
            "weight": listaDogis[5].text.replace("\n", ""),
            "value": listaDogis[6].text.replace("\n", ""),
            "url": listaDogis[0].a["href"]
        })

    return jsonify(listaRetorno)


@cross_origin()
@app.route("/efeitos")
def getEffects():
    cat = BeautifulSoup(requests.get(
        f"{baseURL2}/wiki/Skyrim:Alchemy_Effects").content, "html5lib")
    catDiv = cat.find(
        "div", attrs={"id": "mw-content-text"})
    catTables = catDiv.findAll(
        "table")
    catTable = catTables[3]
    tbody2 = catTable.find("tbody")
    catTable = tbody2.findAll("tr")

    listaRetorno2 = []

    for j in range(1, len(catTable)):
        listaCatis = catTable[j].find("th")
        listaCatis2 = catTable[j].findAll("td")

        listaCatis3 = listaCatis2[0].findAll("a")

        listaRetorno2.append({
            "title": listaCatis.a.text.replace("-h", "-H").replace("Paralyze", "Paralysis"),
            "ingredients": [],
            "icon": "",
            "description": listaCatis2[1].text.replace("<mag> points of poison damage for <dur>", "x points of poison damage for y")
                                              .replace("<mag> will attack anything nearby for <dur>", "x will attack anything nearby for y")
                                              .replace("<mag> points for <dur>", "x points for y")
                                              .replace("by <mag>% for <dur>", "by x% for y")
                                              .replace("<mag> for <dur>", "x for y")
                                              .replace("<mag> flee from combat for <dur>", "x flee from combat for y")
                                              .replace("<mag> points per second for <dur>", "x points per second for y")
                                              .replace("<mag>% of", "y% of")
                                              .replace("<mag>% ", "")
                                              .replace("<dur>", "x")
                                              .replace("<mag>", "x")
        })

        tempIn = []
        for k in range(len(listaCatis3)):
            if listaCatis3[k].text in ["DB", "", "DG", "HF", "[1]"]:
                pass
            else:
                tempIn.append(listaCatis3[k].text)
        listaRetorno2[j-1].update(ingredients=tempIn)
    for i in range(len(listaRetorno2)):
        title = listaRetorno2[i]["title"]
        if "Fire" in title:
            listaRetorno2[i].update(icon="assets/effects/Fire.png")
        elif "Frost" in title or "Slow" in title:
            listaRetorno2[i].update(icon="assets/effects/Ice.png")
        elif "Shock" in title:
            listaRetorno2[i].update(icon="assets/effects/Shock.png")
        elif "Waterbreathing" in title:
            listaRetorno2[i].update(icon="assets/effects/Alteration.png")
        elif "Lingering" in title or "Paralyze" in title:
            listaRetorno2[i].update(icon="assets/effects/Paralyze.png")
        elif "Resist" in title or "Weakness" in title or "Fortify" in title:
            listaRetorno2[i].update(icon="assets/effects/Restoration.png")
        elif "Invisibility" in title:
            listaRetorno2[i].update(icon="assets/effects/Illusion.png")
        elif "Damage" in title or "Ravage" in title or "Fear" in title or "Frenzy" in title:
            listaRetorno2[i].update(icon="assets/effects/Illusion2.png")
        else:
            listaRetorno2[i].update(icon="assets/effects/Heal.png")

    # for i in listaRetorno2:
    #     print(i)
    #     print("\n")
    return jsonify(listaRetorno2)


@cross_origin()
@app.route("/ingredienteInfo", methods=["POST"])
def getIngredienteInfo():
    url = request.json["URL"]
    rat = BeautifulSoup(requests.get(url).content, "html5lib")

    ratDiv = rat.find(
        "div", attrs={"id": "mw-content-text"})

    ratUl = ratDiv.find("ul")
    ratLis = ratUl.findAll("li")

    info = {
        "titleLocation": "",
        "locations": [],
        "background": ""
    }

    ratDiv = list(ratDiv)

    for i in range(len(ratDiv)):
        if '"Background"' in str(ratDiv[i]):
            m = re.findall('(title=\\\".+?\\\")', str(ratDiv[i+2]))
            k = str(ratDiv[i+2])
            for j in m:
                k = k.replace(str(j), str(j.replace(" ", "")))
                info["background"] = str(k).replace("[src]", "")

        if '"Locations"' in str(ratDiv[i]) or '"Acquisition"' in str(ratDiv[i]):
            if "<p>" in str(ratDiv[i+2]):
                m = re.findall('(title=\\\".+?\\\")', str(ratDiv[i+2]))
                k = str(ratDiv[i+2])
                for j in m:
                    k = k.replace(str(j), str(j.replace(" ", "")))
                info["titleLocation"] = str(k)

                if "<ul>" in str(ratDiv[i+4]):
                    ratUl = ratDiv[i+4]
                    ratLis = ratUl.findAll("li")
                    print(ratLis)
                    for i in ratLis:
                        m = re.findall('(title=\\\".+?\\\")', str(i))
                        k = str(i)
                        for j in m:
                            k = k.replace(str(j), str(j.replace(" ", "")))

                        info["locations"].append(str(k).replace(
                            "<li>", "").replace("</li>", "").replace("HF", "").replace("DG", "").replace("DR", ""))
            elif "<p>" in str(ratDiv[i+4]):
                m = re.findall('(title=\\\".+?\\\")', str(ratDiv[i+4]))
                k = str(ratDiv[i+4])
                for j in m:
                    k = k.replace(str(j), str(j.replace(" ", "")))
                info["titleLocation"] = str(k)

                if "<ul>" in str(ratDiv[i+6]):
                    ratUl = ratDiv[i+6]
                    ratLis = ratUl.findAll("li")
                    for i in ratLis:
                        m = re.findall('(title=\\\".+?\\\")', str(i))
                        k = str(i)
                        for j in m:
                            k = k.replace(str(j), str(j.replace(" ", "")))

                        info["locations"].append(str(k).replace(
                            "<li>", "").replace("</li>", "").replace("HF", "").replace("DG", "").replace("DR", ""))

            # elif "<p>" in str(ratDiv[i+6]):
            #     m = re.findall('(title=\\\".+?\\\")', str(ratDiv[i+6]))
            #     k = str(ratDiv[i+6])
            #     for j in m:
            #         k = k.replace(str(j), str(j.replace(" ", "")))
            #     info["titleLocation"] = str(k)

            #     if "<ul>" in str(ratDiv[i+10]):
            #         ratUl = ratDiv[i+10]
            #         ratLis = ratUl.findAll("li")
            #         ratUl2 = ratDiv[i+14]
            #         ratLis2 = ratUl2.findAll("li")
            #         ratUl3 = ratDiv[i+18]
            #         ratLis3 = ratUl3.findAll("li")
            #         for i in ratLis:
            #             m = re.findall('(title=\\\".+?\\\")', str(i))
            #             k = str(i)
            #             for j in m:
            #                 k = k.replace(str(j), str(j.replace(" ", "")))
            #             info["locations"].append(str(k).replace(
            #                 "<li>", "").replace("</li>", "").replace("HF", "").replace("DG", "").replace("DR", ""))
            #         for i in ratLis2:
            #             m = re.findall('(title=\\\".+?\\\")', str(i))
            #             k = str(i)
            #             for j in m:
            #                 k = k.replace(str(j), str(j.replace(" ", "")))
            #             info["locations"].append(str(k).replace(
            #                 "<li>", "").replace("</li>", "").replace("HF", "").replace("DG", "").replace("DR", ""))
            #         for i in ratLis3:
            #             m = re.findall('(title=\\\".+?\\\")', str(i))
            #             k = str(i)
            #             for j in m:
            #                 k = k.replace(str(j), str(j.replace(" ", "")))
            #             info["locations"].append(str(k).replace(
            #                 "<li>", "").replace("</li>", "").replace("HF", "").replace("DG", "").replace("DR", ""))

            else:
                for i in ratLis:
                    m = re.findall('(title=\\\".+?\\\")', str(i))
                    k = str(i)
                    for j in m:
                        k = k.replace(str(j), str(j.replace(" ", "")))

                    info["locations"].append(str(k).replace(
                        "<li>", "").replace("</li>", "").replace("HF", "").replace("DG", "").replace("DR", ""))

            break

    return jsonify(info)


# Inicializando servidor
if __name__ == "__main__":
    app.run(host="10.1.3.87", port=5000, debug=True)  # ip da maquina
