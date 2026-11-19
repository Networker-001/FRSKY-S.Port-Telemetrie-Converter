# FRSKY S.Port to HOTT, Multiplex, Jeti Exbus Converter (RP2040)

Die hier vorgestellte Lösung ermöglicht die Übertragung von Telemetriewerten von 
S.Port Sensoren zu Multiplex, Jeti REX Empfängern, ELRS, Hott und weiteren Empfängern.

Es wird ein kleines Zero Board (Waveshare RP2040-Zero) benötigt, das mit einem Widerstand zwischen
dem Telemetrie-Eingang des Empfängers und dem Telemetrieausgang des Sensors eingefügt wird.

Zur Konfiguration des Boards wird dieses mit einem USB Kabel an einem PC angeschlossen.  
Es öffnet sich ein Windows-Explorerfenster.  
In dieses kopiert man die entsprechende .uf2 Datei aus dem Ordner [Config](./Config) und das wars!


Also ein sehr überschaubares Projekt!

**[Diskussion auf RC-Network](https://www.rc-network.de/threads/telemetrie-wandler-frsky-s-port-nach-hott-crsf.12146885/#post-13374168/)**  

## 3 FRSKY Sensoren am ELRS Empfänger S.Port nach CRSF
![Sensoren](Bilder/Aufbau.jpg)


[Zum physikalischen Aufbau](Doku/Aufbau.md)

[Zum USB MENUE des Konverters](Doku/Konverter.md)

[Übertragene Telemetriewerte](Doku/FRSKY.md)

[Zum orginalen OPENXSENSOR on RP2040 Projekt](Doku/oxs.md)



