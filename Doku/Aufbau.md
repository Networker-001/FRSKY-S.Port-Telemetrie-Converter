## 1. PHYSISCHER HARDWARE-AUFBAU & SYMBOLZEICHNUNG

Das System ist in drei logische Funktionsebenen unterteilt. Der RC-Empfänger bildet die obere Ebene, der RP2040-Konverter vermittelt in der mittleren Ebene, und der iNav Flight Controller schließt das System als breite Basis nach unten ab. Der Aufbau ist hardwareseitig fest auf GPIO 5 als LTM-Eingang fixiert.

### Physikalische Signal- und Verdrahtungs-Matrix (Top-Down)

    +---------------------------------------------------------------+

    |                          RC-EMPFÄNGER                         |
    |                     (z.B. Jeti / Multiplex)                   |
    |                                                               |
    |  [SBUS Out] [+5V]  [GND]                    [GND]    [TLM]    |
    +-----+---------+-----+------------------------+-----------+----+

          |         |     |                        |           |
          |         |     |                        |           |
          |         |     |                        |           |
          |         |     |                        |       [1 kOhm]
          |         |     |                        |           |
          |         |     |                        |           |
          |         |     |                        v           |
          |         |     |                   +----+-----------+----+
          |         |     |                   |   [GND]    [GPIO 0] |  MPX, Hott, FRSKY
          |         |     |                   |            [GPIO 9] |   Jeti       
          |         |     |                   |                     | 
          |         |     |                   |                     |         
          |         |     |                   |        RP2040       |
          |         |     |                   |      KONVERTER      |
          |         |     |                   |                     |
          |         |     |                   |                     |
          |         |     |                   | [5V] [GND] [GPIO 5] |
          |         |     |                   +----+---+---+--------+
          |         |     |                        ^   ^   ^
          |         |     |                        |   |   |
          |         |     |                        |   |   [1 kOhm]
          |         |     |                        |   |   |
          v         v     v                        |   |   |
    +-----+---------+-----+------------------------+---+---+--------+

    |  [RC-SBUS In][+5V] [GND]              [+4,5V] [GND] [UART4 TX]|
    |                                                               |
    |                     FLIGHT CONTROLLER (FC)                    |
    |                             (iNAV)                            |
    +---------------------------------------------------------------+

```text
========================================================================
2. ZULEITUNGEN AM WAVESHARE RP2040-ZERO
========================================================================

                                +-------------------------------------+

                                |             [ USB-C ]               | <-- USB-Anschluss oben
                                +-------------------------------------+
Empfänger [GND] --------------> | [GND]                          [5V] | <--- FC [UART4 +4,5V]

                                | [GND]                         [GND] | <--- FC [UART4 GND]
Empfänger [TLM] <--- [1 kOhm] <-| [GP0] (TLM-Ausgang)           [3V3] |          Hott, Multiplex, FRSKY

                                |                                     |
                                | [GP1]                        [GP29] |
                                | [GP2]          +-------+     [GP28] |
                                | [GP3]          |  BOOT |     [GP27] |
                                | [GP4]          +-------+     [GP26] |
FC [UART4 TX] ----> [1 kOhm] -> | [GP5] (LTM-Eingang)          [GP15] |

                                |                                     |
                                | [GP6]          +-------+     [GP14] |
                                | [GP7]          | RESET |      [RX0] | (GP13)
                                |                +-------+      [TX0] | (GP12)
                                |          (RGB) <-- Status-LED       |
                                +-------------------------------------+

                                   |   |   |   |   |   |   |   |   |
                                  GP8 GP9 GP10 GP11 GND 3V3 GP22 GP21 GP20
                                       |
Empfänger [TLM] <--- [1 kOhm] <--------+ Jeti

```



### Strukturierte Leitungsführung & Schutzbeschaltung:
1. **Verbindung zwischen Empfänger und Flight Controller (Hauptstrom & Steuerung):** 
   * **SBUS:** Das Signalkabel führt als direkte, eng geführte Linie vom **SBUS Out** des oberen Empfängers nach unten an den **RC-SBUS In** des Flight Controllers.
   * **Hauptstromversorgung:** Eine durchgehende **+5V**-Leitung und eine gemeinsame **GND**-Masseleitung führen direkt vom Empfänger nach unten zum Flight Controller.

2. **Verbindung zwischen Flight Controller (UART4) und Konverter (Unterseite):** 
   * **LTM-Signal:** Das Kabel führt vom Ausgang **UART4 TX** des Flight Controllers nach oben an den Pin **GPIO 5** des Konverters. In diese Signalleitung ist ein **1-kOhm-Widerstand** zur Strombegrenzung in Reihe einzulöten.
   * **Schnittstellen-Spannung:** Für die Logikversorgung greift an dieser Stelle eine Versorgungsleitung mit **+4,5V** und der dazugehörigen **GND**-Masse vom Flight Controller zu den Eingängen **5V** und **GND** an der Unterseite des Konverters.

3. **Verbindung zwischen Konverter und Empfänger (Oberseite):** 
   * **Multiplex , Hott:** 
   * **Telemetrie-Signal:** Das Kabel führt vom Ausgang **GPIO 0** des Konverters nach oben zurück an den **TLM**-Eingang des Empfängers. In diese Signalleitung ist ein **1-kOhm-Widerstand** zur Schnittstellenentkopplung in Reihe einzulöten.
   * **Jeti:** 
   * **Telemetrie-Signal:** Das Kabel führt vom Ausgang **GPIO 9** des Konverters nach oben zurück an den **TLM**-Eingang des Empfängers. In diese Signalleitung ist ein **1-kOhm-Widerstand** zur Schnittstellenentkopplung in Reihe einzulöten.


   * **Logik-Masse:** Zwischen dem **GND**-Anschluss des Empfängers und dem Konverter wird eine separate, direkte Masseleitung gezogen, um den Potenzialausgleich des Telemetriekreises sicherzustellen.

