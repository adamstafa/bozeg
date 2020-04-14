# ![](content/logo_transparent.png)

# Boží emulátor Game of Life

## Princip Game of Life

Game of Life je celulární automat připomínající život buněk. Odehrává se na nekonečně velké čtvercové síti buněk, kde každá buňka je buď živá nebo mrtvá. Po nastavení počáteční konfigurace se hra vyvíjí sama a nevyžaduje žádné další interakce s uživatelem.

Stav buněk v další iteraci je určen pomocí 4 pravidel:

* Každá živá buňka s méně než dvěma živými sousedy zemře.
* Každá živá buňka se dvěma nebo třemi živými sousedy zůstává žít.
* Každá živá buňka s více než třemi živými sousedy zemře.
* Každá mrtvá buňka s právě třemi živými sousedy oživne.

Sousedem se myslí buňka, která se dotýká hranou nebo rohem.

## Co je to BOŽEG?

BOŽEG je program s grafickým výstupem simulující Game of Life. Používá stejná pravidla, hrací plocha však není nekonečně velká, ale je obdélníková s konečnými rozměry. Rozměry lze uživatelsky nastavit až na 400 x 400. Levá hrana je spojena s pravou, stejně tak horní se spodní (tzn. buňka by po překročení pravé hrany "přetekla" na levou).

Celý program je napsán v jazyce [Racket](https://racket-lang.org/). Racket je založen na jazyce Scheme, jednom z mnoha dialektů rodiny jazyků LISP.

Program umožňuje

* Zvolit velikost hrací plochy
* Myší měnit stav jednotlivých buněk
* Krokovat iterace
* Automaticky krokovat v pravidelných intervalech
* Nastavit rychlost automatického krokování
* Uložit hrací plochu do souboru
* Nahrát hrací plochu ze souboru

## Instalace a spuštění

Zkompilovaný program lze stáhnout ve formátu .exe přes GitHub v záložce [Releases](https://github.com/adamstafa/bozeg/releases/latest). Není potřeba instalovat žádné další programy, všechny závislosti jsou obsaženy v bozeg.exe.

Alternativně lze stáhnout zdrojový kód a pomocí interpretu Racket spustit soubor gui.rkt.

## Popis kódu

Veškerý kód je rozdělen do 4 samostatných Racket modulů. Každý modul má svůj vlastní soubor. S výjimkou gui.rkt je kód funkcionální, bez vedlejší efektů.

### matrix.rkt

Poskytuje procedury na vytvoření matic (ve smyslu tabulkových dat) a práci s nimi. Data jsou interně reprezentována jako seznam obsahující seznamy, tato skutečnost je ale od uživatele modulu odstíněna. Při práci s maticemi by měl používat pouze metody deklarované v modulu a nespoléhat na to, že se implementace nezmění a data nebudou reprezentována jinak.

### game-of-life.rkt

Poskytuje procedury na vytvoření hrací plochy, 2 povolené hodnoty buněk: `alive` a `dead`, procedury pro vytvoření plochy v další iteraci a obecné nástroje pro manipulaci s plochou.

### board-canvas.rkt

Definuje GUI komponentu `board-canvas`. Tato komponenta rozšiřuje původní komponentu `canvas` z Racket GUI Toolkitu, aby bylo možno snadněji zobrazovat tabulková data.

### gui.rkt

Pomocí Racket GUI Toolkitu vytváří grafické uživatelské rozhraní programu. Veškerá logika hry se odehrává v jiných modulech, gui.rkt pouze zprostředkovává interakci uživatele s těmito moduly.

## Závěr

Moje implementace Game of Life zcela jistě není příliš výkonná a již existující programy nenahradí. Cílem projektu ale bylo vyzkoušet si jazyk LISP a funkcionální paradigma. Funkcionální postupy jsem se snažil používat co nejvíce. Většina dat je immutable a procedury nevytváří vedlejší efekty. Výsledkem je snadno rozšiřitelný, testovatelný, stabilní a poměrně přehledný kód.
