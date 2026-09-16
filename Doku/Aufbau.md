## 1. PHYSISCHER HARDWARE-AUFBAU & SYMBOLZEICHNUNG

Das System ist in drei logische Funktionsebenen unterteilt. Der RC-Empfänger bildet die obere Ebene, der RP2040-Konverter vermittelt in der mittleren Ebene, und der iNav Flight Controller schließt das System als breite Basis nach unten ab. Der Aufbau ist hardwareseitig fest auf GPIO 5 als LTM-Eingang fixiert.

### Physikalische Signal- und Verdrahtungs-Matrix (Top-Down)
```text
+--------------------------+

|    RC-EMPFÄNGER          |
| (z.B. Jeti / Multiplex)  |
|                          |
|  [+5V][GND][TLM]         |
+-----+---+---+------------+

      |   |   |
      |   |   |
      |   |   |
      |   |   [1 kOhm]
      |   |   |
      |   |   |
      v   v   v
+-----+---+---+-------+

|  [+5V][GND][GPIO 0] |  MPX, Hott
|            [GPIO 9] |   Jeti       

|                     | 
|                     |         
|        RP2040       |
|      KONVERTER      |
|                     |
|                     |
| [5V] [GND] [GPIO 2] |
+----+---+---+--------+
     ^   ^   ^

     |   |   |
     |   |   |
     |   |   |
     |   |   |
     |   |   |
+----+---+---+--------+

| [+5V][GND] [TLM]    |
|                     |
|   FRSKY SENSOR      |
|     S.Port          |
+---------------------+

```

```text
========================================================================
2. ZULEITUNGEN AM WAVESHARE RP2040-ZERO
========================================================================

                                +-------------------------------------+

                                |             [ USB-C ]               | <-- USB-Anschluss oben
                                +-------------------------------------+
Empfänger [GND] --------------> | [GND]                          [5V] | <--- Sensor [5V]

                                | [GND]                         [GND] | <--- Sensor [GND]
Empfänger [TLM] <--- [1 kOhm] <-| [GP0] (TLM-Ausgang)           [3V3] |          
Hott, MPX
                                |                                     |
                                | [GP1]                        [GP29] |
 Sensor [TLM]-----------------> | [GP2]          +-------+     [GP28] |
                                | [GP3]          |  BOOT |     [GP27] |
                                | [GP4]          +-------+     [GP26] |
                                | [GP5]                        [GP15] |

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




   * **Logik-Masse:** Zwischen dem **GND**-Anschluss des Empfängers und dem Konverter wird eine separate, direkte Masseleitung gezogen, um den Potenzialausgleich des Telemetriekreises sicherzustellen.

