
# Die Konfiguration über USB ist im Regelfall nicht notwendig!

## Zur Konfiguration des Konverters über USB wird das Programm Coolterm empfohlen.

1. Konverter per USB mit einem Laptop verbinden.
2. Coolterm starten.
3. Nach Drücken der Enter-Taste erscheint das originale openXsensor on RP 2040 Menü.

## Folgende Einstellungen sind hilfreich:

* **FV + Enter**: Anzeigen der empfangenen Telemetriewerte
* **inav = 2**: Senden von Telemetriewerten zum Empfänger ohne INAV
* **?**: Hilfefunktion

### Befehlsübersicht der Einstellungen für INAV

#### --- INAV TELEMETRIE-KONVERTER BEFEHLE ---
> **HINWEIS:** Eingaben müssen mit Leerzeichen um das `=` erfolgen (z. B. `INAV = 1`).

1. **Eingangs-Modus (iNav LTM an GPIO 5):**
   * `INAV = 1` : Schaltet den Konverter-Modus ein
   * `INAV = 2` : Schaltet den Konverter-Modus mit simulierten Festwerten ein
   * `INAV = 0` : Deaktiviert den iNav-Eingang

2. **Ausgangs-Protokoll (Auswahl für Empfänger):**
   * `PROTOCOL = M` : Schaltet den Ausgang auf MULTIPLEX um
   * `PROTOCOL = E` : Schaltet den Ausgang auf JETI (EXBUS) um
   * `PROTOCOL = H` : Schaltet den Ausgang auf Graupner HoTT um

3. **Ausgangs-Port (Auswahl für Empfänger):**
   * `TLM = 0`   : TLM Port für HoTT oder MULTIPLEX
   * `TLM = 255` : TLM Port für Jeti
   * `PRI = 255` : Port für HoTT oder MULTIPLEX
   * `PRI = 9`   : Port für Jeti

4. **Einstellungen dauerhaft sichern:**
   * `SAVE` : Speichert alle Parameter im Flash-Speicher des Pico

***



