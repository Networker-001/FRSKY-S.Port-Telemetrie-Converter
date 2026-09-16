
## DER Technische HINTERGRUND

Es wurde oftmals berichtet, dass die direkte Nutzung des Jeti EXBUS-Protokolls in der iNav-Firmware zu Instabilitäten führen kann. Durch Fehler im iNav-Quellcode und Inkompatibilitäten bei der Kompilierung mit neueren Compiler-Versionen kam es bei aktiver EXBUS-Verbindung regelmäßig zu Systemausfällen (Freezes) des Flight Controllers. Diese traten vor allem bei schnellen Steuerbewegungen oder bei der Übertragung von mehr als 16 Kanälen auf. Zudem war die Rückrichtung für Telemetriedaten fehlerhaft implementiert, was zu einfrierenden oder fehlenden Werten auf dem Sender führte. 

Mit INAV Release 7 sind Änderungen von Betaflight übernommen worden, die laut Aussagen von Testern zu einer Stabilisierung geführt haben, es soll aber noch zu Telemetrie Ausfällen kommen.
Es bleibt immer noch ein Beigeschmack. Jeder muss für sich selber entscheiden, wieviel Sicherheit er braucht. Auf der einen Seite ein bidirektionales Protokol und auf der Anderen Seite getrennte Leitungen für Telemetrie und Steuerung.


Multiplex-Protokolle werden von iNav nicht nativ unterstützt.

