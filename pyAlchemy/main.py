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
    global ratLis
    ratLis = ratUl.findAll("li")

    info = {
        "titleLocation": "",
        "locations": [],
        "innerLocations": {"indexes": [], "inners": []},
        "background": ""
    }

    ratDiv = list(ratDiv)

    def ratUlLis(currentUL):
        global ratLis
        if currentUL != "":
            ratLis = currentUL.findAll("li")
        aux = ""
        for item in range(len(ratLis)):
            m = re.findall('(title=\\\".+?\\\")', str(ratLis[item]))
            k = str(ratLis[item])
            for j in m:
                k = k.replace(str(j), str(j.replace(" ", "")))
            if "<ul>" in str(k):
                aux = str(k)

                for p in range(len(aux)):
                    if p < len(aux) - 4:
                        if aux[p] + aux[p+1] + aux[p+2] + aux[p+3] == "<ul>":
                            print("oi")
                            info["locations"].append(aux[:p].replace("<li>", "").replace(
                                "HF", "").replace("DG", "").replace("DR", ""))
                            info["innerLocations"]["indexes"].append(item)
                            info["innerLocations"]["inners"].append(
                                aux[p:].replace("HF", "").replace("DG", "").replace("DR", ""))
                            break

                # info["locations"].append(str(k).replace("\n<ul><li>", "▫").replace("\n</li><li>", "▫").replace(
                #     "<li>", "").replace("</li>", "").replace("HF", "").replace("DG", "").replace("DR", ""))
            elif str(k) not in aux:
                info["locations"].append(str(k).replace(
                    "<li>", "").replace("</li>", "").replace("HF", "").replace("DG", "").replace("DR", ""))

    def addTitleLocation(position):
        m = re.findall('(title=\\\".+?\\\")', str(ratDiv[position]))
        k = str(ratDiv[position])
        for j in m:
            k = k.replace(str(j), str(j.replace(" ", "")))
        info["titleLocation"] = str(k)

    for i in range(len(ratDiv)):
        if '"Background"' in str(ratDiv[i]):
            m = re.findall('(title=\\\".+?\\\")', str(ratDiv[i+2]))
            k = str(ratDiv[i+2])
            for j in m:
                k = k.replace(str(j), str(j.replace(" ", "")))
            info["background"] = str(k).replace("[src]", "").replace("[1]", "")

        if '"Locations"' in str(ratDiv[i]) or '"Acquisition"' in str(ratDiv[i]) or '"Location"' in str(ratDiv[i]):

            if "<p>" in str(ratDiv[i+2]) and "<ul>" in str(ratDiv[i+4]) and "<p>" in str(ratDiv[i+6]) and "<ul>" in str(ratDiv[i+8]):
                addTitleLocation(i+2)

                ratUl = ratDiv[i+4]
                ratUlLis(ratUl)

                temp = str(ratDiv[i+6])
                info["locations"].append(temp)

                ratUl = ratDiv[i+8]
                ratUlLis(ratUl)

            elif "<dl>" in str(ratDiv[i+2]) and "<ul>" in str(ratDiv[i+4]) and "<dl>" in str(ratDiv[i+6]) and "<ul>" in str(ratDiv[i+8]):
                temp = str(ratDiv[i+2]).replace("\n", ":\n")
                info["locations"].append(temp.upper())

                ratUl = ratDiv[i+4]
                ratUlLis(ratUl)

                temp = str(ratDiv[i+6]).replace("\n", ":\n")
                info["locations"].append(temp.upper())

                ratUl = ratDiv[i+8]
                ratUlLis(ratUl)

            elif ("<h3>" in str(ratDiv[i+2]) and "<ul>" in str(ratDiv[i+4]) and "<h3>" in str(ratDiv[i+6]) and "<ul>" in str(ratDiv[i+8])) or ("<h3>" in str(ratDiv[i+2]) and "<ul>" in str(ratDiv[i+4]) and "<h3>" in str(ratDiv[i+6]) and "<ul>" in str(ratDiv[i+8]) and "<h3>" in str(ratDiv[i+10]) and "<ul>" in str(ratDiv[i+12])):
                temp = str(ratDiv[i+2].text).replace("Edit", ":")
                info["locations"].append(temp.upper())

                ratUl = ratDiv[i+4]
                ratUlLis(ratUl)

                temp = str(ratDiv[i+6].text).replace("Edit", ":")
                info["locations"].append(temp.upper())

                ratUl = ratDiv[i+8]
                ratUlLis(ratUl)

                if "<h3>" in str(ratDiv[i+10]) and "<ul>" in str(ratDiv[i+12]):
                    temp = str(ratDiv[i+10].text).replace("Edit", ":")
                    info["locations"].append(temp.upper())

                    ratUl = ratDiv[i+12]
                    ratUlLis(ratUl)

            elif "<p>" in str(ratDiv[i+6]) and "<h3>" in str(ratDiv[i+8]) and "<ul>" in str(ratDiv[i+10]) and "<h3>" in str(ratDiv[i+12]) and "<ul>" in str(ratDiv[i+14]) and "<h3>" in str(ratDiv[i+16]) and "<ul>" in str(ratDiv[i+18]) and "<h3>" in str(ratDiv[i+20]) and "<p>" in str(ratDiv[i+22]):
                addTitleLocation(i+6)

                aux = 6
                for g in range(3):
                    aux = aux + 2
                    temp = str(ratDiv[i+aux].text).replace("Edit", ":")
                    info["locations"].append(temp.upper())

                    aux = aux + 2
                    ratUl = ratDiv[i+aux]
                    ratUlLis(ratUl)

                temp = str(ratDiv[i+20].text).replace("Edit", ":")
                info["locations"].append(temp.upper())

                info["locations"].append(str(ratDiv[i+22]))

            elif "<p>" in str(ratDiv[i+2]) and "<h3>" in str(ratDiv[i+4]) and "<ul>" in str(ratDiv[i+6]) and "<h3>" in str(ratDiv[i+8]) and "<ul>" in str(ratDiv[i+10]):
                addTitleLocation(i+2)

                aux = 2
                for g in range(2):
                    aux = aux + 2
                    temp = str(ratDiv[i+aux].text).replace("Edit", ":")
                    info["locations"].append(temp.upper())

                    aux = aux + 2
                    ratUl = ratDiv[i+aux]
                    ratUlLis(ratUl)

            elif "<p>" in str(ratDiv[i+2]) and "Recurring" in str(ratDiv[i+4]) and "<ul>" in str(ratDiv[i+6]):
                addTitleLocation(i+2)

                ratUl = ratDiv[i+6]
                ratUlLis(ratUl)

            elif "<p>" in str(ratDiv[i+2]) and "<p>" in str(ratDiv[i+3]) and "<ul>" in str(ratDiv[i+5]):
                addTitleLocation(i+2)
                info["titleLocation"] = info["titleLocation"]+str(ratDiv[i+3])

                ratUl = ratDiv[i+5]
                ratUlLis(ratUl)

            elif "<p>" in str(ratDiv[i+2]) and "<ul>" in str(ratDiv[i+4]) and "<p>" in str(ratDiv[i+6]):
                addTitleLocation(i+2)

                ratUl = ratDiv[i+4]
                ratUlLis(ratUl)

                m = re.findall('(title=\\\".+?\\\")', str(ratDiv[i+6]))
                k = str(ratDiv[i+6])
                for j in m:
                    k = k.replace(str(j), str(j.replace(" ", "")))
                info["locations"].append(str(k))

            elif "<p>" in str(ratDiv[i+2]) and "<ul>" in str(ratDiv[i+4]):
                addTitleLocation(i+2)

                ratUl = ratDiv[i+4]
                ratUlLis(ratUl)

            elif "<p>" in str(ratDiv[i+2]):
                addTitleLocation(i+2)

            elif "<p>" in str(ratDiv[i+4]):
                addTitleLocation(i+4)

                if "<ul>" in str(ratDiv[i+6]):
                    ratUl = ratDiv[i+6]
                    ratUlLis(ratUl)

            else:
                print("hey")
                ratUlLis("")

            break

    return jsonify(info)


# Inicializando servidor
if __name__ == "__main__":
    app.run(host="10.1.3.87", port=5000, debug=True)  # ip da maquina
