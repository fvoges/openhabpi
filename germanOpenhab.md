# Einleitung #

Diese Seite soll Interessierten Einsteigern den Einstieg in die openhab-Welt vereinfachen.

Für Fragen und Anregungen sei an dieser Stelle an das [KNX-User-Forum](http://www.knx-user-forum.de/openhab/) verwiesen.

# Begriffe #

| Begriff | Bedeutung | Ordner/Datei |
|:--------|:----------|:-------------|
| Items   | Dinge wie Zahlenwerte, Schalter/Lichter sind Items | configurations/items |
| Rules   | Regeln - Programme, Logiken, Zeitschaltuhren etc.  | configurations/rules |
| Scripts | Kleine Programme, die aus Regeln heraus aufgerufen werden können | configurations/scripts |
| Actions | Aktionen/Befehle wie das Versenden von Mails, das Ändern eines Lichts etc. Eine Liste findet sich [hier](https://code.google.com/p/openhab/wiki/Actions) |              |
| Persistence | Kümmert sich um die Speicherung von Zuständen. Werte können in Rules/Scripts abgefragt und ausgewertet werden  | configurations/persist |
| Classic UI | Die Web-Ansicht von openhab (Siehe auch [openhab-Wiki](https://code.google.com/p/openhab/wiki/Features#User_Interfaces))|              |
| Binding | Ein Binding ist eine Erweiterung für openhab und ermöglicht die Anbindung weiterer Systeme/Geräte/Funktionen. Eine Liste gibt es [hier](https://code.google.com/p/openhab/wiki/Features#Bindings) | addons/      |
| Binding Config | Teil der Item-Definition, der ein Item mit einem Binding verknüpft |              |

# Schnelleinstieg auf Windows #

## Voraussetzungen ##

Wenn [Java](http://www.java.com/inc/BrowserRedirect1.jsp?locale=de) auf deinem Windows-PC installiert ist, ist die Installation von openhab sehr einfach: Bitte lade zuerst die aktuell stabile Version von openhab [von hier ](https://code.google.com/p/openhab/downloads/list) herunter. Du benötigst zum ersten Test nur die runtime und die demo.


Du solltest nun zwei Dateien heruntergeladen haben, die ähnlich heißen wie openhab-runtime-1.2.0.zip und openhab-demo-1.2.0.zip

## Entpacken der Runtime ##

Das Bais-Paket Runtime enthält die notwendige Basis von openhab. Diese ZIP-Datei musst du nun in einen Ordner entpacken. Bitte achte darauf, dass möglichst keine Leerzeichen im Pfad zu deinem ausgewählten Ordner sind. Ein guter Ort wäre z.B. C:\openhab\ oder C:\Programme\openhab.

## Entpacken der Demo ##

Um auf eine kleine Spiel-Umgebung aufbauen zu können, bedienen wir uns der Demo-Datei. Diese wird nun in den selben Ordner entzippt. Dabei werden einige Dateien ersetzt.

## Starten der Umgebung ##

Im Hauptordner von openhab (z.B. C:\openhab, also der von dir ausgewählte Ordner) liegt eine Datei namens start.bat. Diese kannst du nun mit einem Doppelklick starten.

Es öffnet sich ein schwarzes Fenster und openhab startet. Wenn die Zeile "started Classic UI" vorbeigezogen ist, kannst du auf http://localhost:80080/openhab.app?sitemap=demo zugreifen und hast eine ähnliche Installation wie auf dem [offizellen Demo-System](http://demo.openhab.org:8080/openhab.app?sitemap=demo).

# Anpassen an deine Bedürfnisse #

## Auswahl von Bindings ##
| Binding | Zweck |
|:--------|:------|
| exec    | Andere Programme starten |
| fritzbox | Reagieren auf Anrufe |
| http    | Kann Webseiten aufrufen und den Inhalt auswerten. Kann auch Werte an Webseiten senden |
| snmp    | Kann Mails verschicken |
| ntp     | Liefert [NTP](http://de.wikipedia.org/wiki/Network_Time_Protocol)-Uhrzeit |
| networkhealth | Testet IPs auf Erreichbarkeit |
| knx     | Bindet den KNX-Bus (falls vorhanden) über einen IP-Router ein |
| persistence.rrd4j | Speichern von Zuständen und Erzeugung von Diagrammen |


## Einrichten der Items ##

Sobald alle Bindings für den späteren Betrieb ausgewählt sind, sind diese in dem Ordner addons abzulegen.

Damit openhab weiss, was welches Item bewirken soll, muss die Binding Config angepasst werden - dies geschieht über die items-Datei in configurations/items/.

Hier eine Beispieldefinition für eine Lampe:
```
Switch Licht_Spiegel "Spiegelleuchte" 		(Bad, Lampen)
```

Das ist zunächst nur eine Bekanntmachung eines schaltbaren ("Switch") Items mit dem internen Namen "Licht\_Spiegel" an openhab. Der Text "Spiegelleuchte" steht in den Benutzeroberflächen links und ist der Text, der dem Benutzer sichtbar ist. Die zwei Worte in Klammern sind die Gruppen, denen dieser Item zugeordnet werden soll.

Wie auffällt,