
### DIE SYSTEMLÖSUNG DURCH DIESEN KONVERTER

Dieser Konverter löst das Problem, indem er die kritische Flugsteuerung und die Telemetrieverarbeitung physisch vollständig voneinander trennt. Dadurch haben Telemetrie-Verarbeitungsfehler im Flight Controller keine Auswirkungen auf die Steuerbarkeit des Modells.

Das Sicherheitskonzept basiert auf drei Säulen:

1. **Flugsteuerung über SBUS:** 
   Die Übertragung der Steuerbefehle vom Empfänger zum Flight Controller erfolgt über das standardisierte SBUS-Protokoll. SBUS arbeitet als reiner, robuster Einweg-Kanal ohne Rückrichtung. Da iNav bei diesem Protokoll keine Telemetriedaten verarbeiten muss, läuft die Flugsteuerung fehlerfrei. Ein Absturz der Steuerung durch Telemetrie-Überlastung ist ausgeschlossen.
2. **Autarke Telemetrie-Übersetzung (LTM):** 
   Der Flight Controller gibt seine Sensordaten über das ressourcenschonende LTM-Protokoll (Lightweight Telemetry) aus. Der eigenständige RP2040-Konverter fängt diesen Datenstrom an GPIO 5 ab und übernimmt die Übersetzung in das Zielformat (JETI EXBUS oder Multiplex) auf einem separaten Prozessor.
3. **Unabhängiger Zusatzkanal:** 
   Der Konverter speist die aufbereiteten Werte direkt in den Telemetrie-Eingang des Empfängers ein. Die Berechnung der Telemetrie erfolgt somit außerhalb des Flight Controllers. Selbst bei einer Störung auf der Telemetrieleitung bleibt der SBUS-Steuerkanal davon unberührt, und das Modell lässt sich sicher steuern.

