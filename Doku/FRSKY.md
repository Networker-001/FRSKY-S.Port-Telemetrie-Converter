# Übersicht der verarbeiteten FrSky S.Port Telemetriewerte

Dieses Dokument beschreibt alle vom Konverter ausgewerteten FrSky S.Port Application-IDs, die interne Bit-Aufteilung der 32-Bit-Nutzdaten (`val`), die erforderliche Einheiten-Skalierung sowie die Zuordnung zu den internen **`openXsensor` (`fields[...]`) Zielfeldern**.

---

## 1. Zuordnungstabelle (FrSky S.Port -> openXsensor)

Alle ID-Bereiche (`0x...0` bis `0x...F`) werden durch die Index-Filterung (`filterFrSkyId`) automatisch auf ihre Basis-ID normalisiert.

| FrSky Basis-ID (HEX) | Sensor-Typ / Beschreibung | Bit-Aufteilung in `val` (32-Bit) | FrSky Roh-Einheit | Skalierung im Code | oXs Zielfeld (`fields[...]`) | oXs Ziel-Einheit |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`0x0100`** | Vario / Baro Höhe | `int32_t` (32 Bit) | `0.01 m` (`cm`) | `* 1` | `RELATIVEALT` | `cm` (`0.01 m`) |
| **`0x0110`** | Vario Steigrate (VSpeed) | `int32_t` (32 Bit) | `0.01 m/s` (`cm/s`) | `* 1` | `VSPEED` | `cm/s` |
| **`0x0200`** | Stromsensor (Current) | `uint32_t` (32 Bit) | `0.1 A` (`100 mA`) | `* 100` | `CURRENT` | `mA` |
| **`0x0210`** | Spannungssensor (VFAS) | `uint32_t` (32 Bit) | `0.01 V` (`10 mV`) | `* 10` | `MVOLT` | `mV` |
| **`0x0300`** | Einzelzellenspannung (FLVSS / LiPo) | Bits `0–3`: Start-Zelle, Bits `4–7`: Zellenzahl, Bits `8–19`: Zelle N, Bits `20–31`: Zelle N+1 | `0.002 V` (`2 mV`) | `* 2` | `CELL_1` .. `CELL_6`, `CELL_MIN`, `MVOLT` | `mV` |
| **`0x0800`** | GPS Koordinaten (Lat / Lon) | Bit `31`: Typ, Bit `30`: Vorzeichen, Bits `0–29`: Wert | `1/600000 Grad` | Umrechnung in `1e-7 Grad` | `LATITUDE` / `LONGITUDE` | `0.0000001°` |
| **`0x0820`** | GPS Höhe | `int32_t` (32 Bit) | `0.01 m` (`cm`) | `* 1` | `ALTITUDE` | `cm` (`0.01 m`) |
| **`0x0830`** | GPS Geschwindigkeit (Groundspeed) | `uint32_t` (32 Bit) | `0.001 Knoten` | `* 0.051444` | `GROUNDSPEED` | `cm/s` |
| **`0x0840`** | GPS Kurs (im FrSky-Stream nicht genutzt) | — | — | Überschrieben durch RTH | `HEADING` *(RTH-Steuersignal)* | `0` – `10000` (`5000` = Neutral) |
| **`0x0850`** | GPS Datum & Uhrzeit | Gepacktes Datums-/Zeitformat | Jahr/Monat/Tag/Std/Min/Sek | Bit-Extraktion | `GPS_DATE` / `GPS_TIME` | Datum / UTC |
| **`0x0880`** | UNI-Sens / Vario Absolute Höhe | `int32_t` (32 Bit) | `0.01 m` (`cm`) | `* 1` | `RELATIVEALT` & `ALTITUDE` | `cm` (`0.01 m`) |
| **`0x0B50`** | ESC Akkuspannung | Untere 16 Bit (`Bits 0–15`, `uint16_t`) | `0.01 V` (`10 mV`) | `* 10` | `MVOLT` | `mV` |
| **`0x0B50`** | ESC Motorstrom | Obere 16 Bit (`Bits 16–31`, `uint16_t`) | `0.01 A` (`10 mA`) | `* 10` | `CURRENT` | `mA` |
| **`0x0B60`** | ESC Motordrehzahl (RPM) | Untere 16 Bit (`Bits 0–15`, `uint16_t`) | `100 U/min` | `* 100` | `RPM` | `U/min` (`RPM`) |
| **`0x0B60`** | ESC Verbrauch (wird ignoriert) | Obere 16 Bit (`Bits 16–31`, `uint16_t`) | `1 mAh` | Selbstberechnung durch oXs | `CAPACITY` *(aus `CURRENT`)* | `mAh` |
| **`0x0B70`** | ESC Reglertemperatur | Untere 16 Bit (`Bits 0–15`, `int16_t`) | `1 °C` (mit Vorzeichen) | `* 1` | `TEMP1` | `°C` |
| **`0x0E50`** | SBEC Ausgangsspannung | Untere 16 Bit (`Bits 0–15`, `uint16_t`) | `0.01 V` (`10 mV`) | `* 10` | `RESERVE1` | `mV` |
| **`0x0E50`** | SBEC Ausgangsstrom | Obere 16 Bit (`Bits 16–31`, `uint16_t`) | `0.01 A` (`10 mA`) | `* 10` | `RESERVE2` | `mA` |

---

## 2. Besonderheiten & Spezialfunktionen im Code

Im Vergleich zu einer reinen 1:1-Protokollübersetzung enthält der Konverter folgende gezielte Anpassungen und technische Hinweise:

* **FrSky GPS & RTH-Integration (`Sats` und `HEADING`):**  
  Standard-FrSky-GPS-Sensoren übermitteln über den S.Port keine Satellitenanzahl (`Sats`) und keinen nutzbaren Kurs (`Heading`). Hier greift unsere RTH-Funktion direkt ein: Sobald der Home-Punkt erfolgreich gespeichert wurde (Home-Lock), setzt das System den Satellitenwert fest auf **`12` Sats** (bzw. inklusive Status-Offset für die Telemetrieanzeige) und gibt über das Feld **`HEADING`** die berechneten Lenk- und Steueranweisungen für den Sender aus.
* **Begrenzte GPS-Auflösung und Wiederholrate über FrSky S.Port:**  
  Das FrSky-S.Port-Protokoll (`0x0800`) überträgt Längen- und Breitengrade (`LAT` / `LON`) in `1/600000` Grad, wobei die letzten zwei Stellen bei der Übertragung bzw. Umrechnung auf `00` gekappt werden. Dadurch entsteht eine deutlich gröbere örtliche Rasterung in Kombination mit einer niedrigen Wiederholrate (typischerweise `1 Hz`, abwechselnd für Breite und Länge). Im Vergleich zu einem direkt per UART angeschlossenen u-blox-GPS (`5 Hz` bis `10 Hz` mit voller Nachkomma-Auflösung) arbeitet RTH über den FrSky-Sensor daher gröber und träger – für größere Kreisradien (`100–150 m`) beim Segler reicht es aus, für enge Radien oder RC-Car-Tests ist ein direktes u-blox-GPS jedoch klar im Vorteil.
* **Index-Filterung bei mehreren Sensoren am S.Port (`0x0xxI` vs. `0x0xx0`):**  
  Wenn mehrere Sensoren gleichzeitig am S.Port betrieben werden (z. B. ein **SM UniSens-E** zusammen mit einem weiteren Sensor wie einem Vario oder Regler), kann im UniSens-E ein eigener Sensor-Index `I` eingestellt werden (die Application-IDs enden dann auf `0x0xxI`, z. B. `0x0102`, `0x0202`). Der Konverter erkennt diesen eingestellten Index beim ersten Paket automatisch und rechnet die Pakete auf die jeweilige Basis-ID herunter. Im Zusammenspiel mit weiteren Sensoren am Bus werden ansonsten nur die regulären Basis-IDs (`0x0xx0`) ausgewertet, sodass sich Sensoren auf denselben Telemetrie-Kanälen nicht gegenseitig überschreiben.
* **Eigene Verbrauchsberechnung (`CAPACITY`):**  
  Die vom UniSens-E (oder Regler) gesendeten Kapazitäts- bzw. Verbrauchswerte (`mAh`) werden bewusst **nicht** übernommen. Stattdessen berechnet `openXsensor` die verbrauchte Kapazität (`CAPACITY`) anhand des gemessenen Stroms (`CURRENT`) über die Zeit eigenständig.


---

## 3. Aufbau kombinierter 32-Bit-Pakete

Einige FrSky-Sensoren übertragen **mehrere Messwerte gleichzeitig** innerhalb eines einzigen 32-Bit-Datenpakets (`val`), um die Bus-Auslastung auf dem S.Port gering zu halten:

* **Einzelzellensensor (`0x0300` / FLVSS):** Überträgt pro Paket jeweils **zwei 12-Bit-Spannungswerte** (Zelle `N` in Bits `8–19` und Zelle `N+1` in Bits `20–31`). Durch Multiplikation mit `2` entsteht direkt der Wert in Millivolt (`mV`). Zusätzlich lassen sich daraus automatisch die schwächste Zelle (`CELL_MIN`) sowie die Gesamtspannung (`MVOLT`) berechnen.
* **Untere 16 Bit (`Bits 0–15`):** Werden bei ESC/SBEC-Paketen über die Bitmaske `(val & 0xFFFF)` extrahiert.
* **Obere 16 Bit (`Bits 16–31`):** Werden durch Rechtsverschiebung und Maskierung `((val >> 16) & 0xFFFF)` extrahiert.
* **Vorzeichenbehaftete Werte (Temperatur `0x0B70`):** Werden nach dem Maskieren explizit auf `int16_t` gecastet (`(int16_t)(val & 0xFFFF)`), damit negative Temperaturen unter `0 °C` (Zweierkomplement) korrekt als Minuswerte an `openXsensor` übergeben werden.
