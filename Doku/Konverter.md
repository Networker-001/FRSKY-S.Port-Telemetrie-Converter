
# Die Konfiguration über USB ist im Regelfall nicht notwendig!

## Zur Konfiguration des Konverters über USB wird das Programm Coolterm empfohlen.

1. Konverter mit gedrückter Boot-Taste per USB mit einem Laptop verbinden.
2. Coolterm starten.
3. Nach Drücken der Enter-Taste erscheint das originale openXsensor on RP 2040 Menü.

## Folgende Einstellungen sind hilfreich:

* **FV + Enter**: Anzeigen der empfangenen Telemetriewerte
* **conv = 2**: Senden von Telemetriewerten zum Empfänger ohne INAV
* **?**: Hilfefunktion

### Befehlsübersicht der Einstellungen für den Konverter

#### --- INAV TELEMETRIE-KONVERTER BEFEHLE ---

1. **Eingangs-Modus (FRSKY an GPIO 2):**
   * `conv= 3` : Schaltet den Konverter-Modus ein
   * `conv = 4` : Schaltet den Konverter-Modus mit simulierten Festwerten ein
   * `conv = 0` : Deaktiviert den iNav-Eingang
          
2. **Eingangs-PIN (FRSKY an GPIO 2-4):**
   * `conv_pin= 3` : Schaltet den Konverter-PIN auf GPIO 3 
   
3. **Ausgangs-Protokoll (Auswahl für Empfänger):**
   * `PROTOCOL = M` : Schaltet den Ausgang auf MULTIPLEX um
   * `PROTOCOL = E` : Schaltet den Ausgang auf JETI (EXBUS) um
   * `PROTOCOL = H` : Schaltet den Ausgang auf Graupner HoTT um
   * `PROTOCOL = C` : Schaltet den Ausgang auf ELRS CRSF um

4. **Ausgangs-Port (Auswahl für Empfänger):**
   * `TLM = 0`   : TLM Port für HoTT, MULTIPLEX oder CSRF
   * `TLM = 255` : TLM Port für Jeti
   * `PRI = 255` : Port für HoTT, MULTIPLEX oder CSRF
   * `PRI = 9`   : Port für Jeti

5. **Einstellungen dauerhaft sichern:**
   * `SAVE` : Speichert alle Parameter im Flash-Speicher des Pico
     
6. **Debuggen:**
   * `FV`   : Zeigt empfangene Werte
   * `DT=Y` : Zeigt empfangene Protokolle
***



