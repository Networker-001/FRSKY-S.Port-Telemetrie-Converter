# Telemetry Fields Calculated and Transmitted per Protocol

This document lists the telemetry fields calculated by **openXsensor on RP2040** and shows how they are mapped and transmitted for each supported receiver protocol.

---

## 1. S.Port or FBus Protocols (FrSky)

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **VOLT1** | `0.001 V` | `V1` pin is defined | `VFAS` (`0x0210`) | `0.01 V` |
| **VOLT2** | `0.001 V` = `0.001 A` | `V2` pin is defined | `Current` (`0x0200`) | `0.001 A` |
| **Capacity** | `mAh` | `V2` pin is defined (reset after power down) | `DIY` (`0x5123`) | `mAh` |
| **VOLT3** | `0.001 V` | `V3` pin is defined & `TEMP=0` or `255` | `DIY` (`0x5113`) | `0.001 V` |
| **VOLT3 (Temp)** | `0.001 V` | `V3` pin is defined & `TEMP=1` or `2` | `T1` (`0x0400`) | `degree` |
| **VOLT4** | `0.001 V` | `V4` pin is defined & `TEMP=0` or `255` | `DIY` (`0x5114`) | `0.001 V` |
| **VOLT4 (Temp)** | `0.001 V` | `V4` pin is defined & `TEMP=2` | `T2` (`0x0410`) | `degree` |
| **Baro Alt** | `cm` | Baro is installed (and `SCL`/`SDA` defined) | `Altitude` (`0x0100`) | `cm` |
| **Vspeed** | `cm/s` | Baro is installed (and `SCL`/`SDA` defined; uses MPU6050 too if installed) | `Vspeed` (`0x0110`) | `cm/s` |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | `long` (`0x0800`) | special format |
| **GPS Latitude** | — | Same as above | `lat` (`0x0800`) | special format |
| **GPS Speed** | `cm/s` | Same as above | `GPS ground speed` (`0x0830`) | `0.001 kts` |
| **GPS Course** | `0.01 degree` | Same as above | `GPS heading` (`0x0840`) | `0.01 degree` |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`; note: some handsets calculate relative alt) | `GPS Alt` (`0x0820`) | `cm` |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | `DIY` (`0x5100`) | `unit (+100)` |
| **GPS Date** | `YYMMDD0xFF` | Same as above | `GPS date` (`0x0850`) | special format |
| **GPS Time** | `HHMMSS0x00` | Same as above | `GPS time` (`0x0850`) | special format |
| **GPS PDOP** | `0.01` | Same as above | `GPS PDOP` (`0x5101`) | `0.01` |
| **GPS Bearing from Home** | `degree` | Same as above | `DIY` (`0x5102`) | `degree` |
| **GPS Distance from Home** | `m` | Same as above | `DIY` (`0x5103`) | `m` |
| **GPS Cumulative Distance** | `m` | Same as above | `DIY` (`0x5104`) | `m` |
| **RPM** | — | `RPM` pin is defined | `RPM` (`0x0500`) | `RPM` |
| **ADS1115** | `0.001 V` (4x2) | 1 or 2 ADS1115 installed + `SCL`/`SDA` defined | `DIY` (`0x5131` / `0x5138`) | `mV` |
| **Pitch** | `0.01 degree` | MPU6050 is installed (and `SCL`/`SDA` defined) | `DIY` (`0x5120`) | `0.01 degree` |
| **Roll** | `0.01 degree` | Same as above | `DIY` (`0x5121`) | `0.01 degree` |
| **Airspeed** | `cm/s` | MS4525 / SDP3x is installed (and `SCL`/`SDA` defined) | `Airspeed` (`0x0A00`) | `0.1 kts` |
| **Comp. Vspeed** | `cm/s` | Baro + MS4525 / SDP3x are installed | `Vspeed` (`0x011F`) | `cm/s` |
| **Sbus Hold Frames** | `%` | Sbus(2) is used | `DIY` (`0x5124`) | `%` |
| **Sbus Failsafe Frames** | `count` | Same as above | `DIY` (`0x5125`) | no unit |
| **Acc X** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | `AccX` (`0x0700`) | `0.001 g` |
| **Acc Y** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | `AccY` (`0x0710`) | `0.001 g` |
| **Acc Z** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | `AccZ` (`0x0720`) | `0.001 g` |

---

## 2. ELRS / CRSF Protocol

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **VOLT1** | `0.001 V` | `V1` pin is defined | `Volt` | `0.1 V` |
| **VOLT2** | `0.001 V` = `0.001 A` | `V2` pin is defined | `Current` | `0.1 A` |
| **Capacity** | `mAh` | `V2` pin is defined (reset after power down) | `Capacity` | `mAh` |
| **VOLT3** | `0.001 V` | `V3` pin is defined | *not transmitted* | — |
| **VOLT4** | `0.001 V` | `V4` pin is defined | *not transmitted* | — |
| **Baro Alt** | `cm` | Baro is installed (and `SCL`/`SDA` defined) | `Altitude` | `dm` |
| **Vspeed** | `cm/s` | Baro is installed (and `SCL`/`SDA` defined; uses MPU6050 too if installed) | `Vspeed` | `cm/s` |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | `longitude` | special format |
| **GPS Latitude** | — | Same as above | `latitude` | special format |
| **GPS Speed** | `cm/s` | Same as above | `GPS ground speed` | `0.1 km/h` |
| **GPS Course** | `0.01 degree` | Same as above | `heading` | `0.01 degree` |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`; note: some handsets calculate relative alt) | `GPS Alt` | `m` |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | `Num of satellites` | `unit (+100)` |
| **GPS Date** | `YYMMDD0xFF` | Same as above | *not transmitted* | — |
| **GPS Time** | `HHMMSS0x00` | Same as above | *not transmitted* | — |
| **GPS PDOP** | `0.01` | Same as above | *not transmitted* | — |
| **GPS Bearing from Home** | `degree` | Same as above | *not transmitted* | — |
| **GPS Distance from Home** | `m` | Same as above | *not transmitted* | — |
| **GPS Cumulative Distance** | `m` | Same as above | *not transmitted* | — |
| **RPM** | — | `RPM` pin is defined | *not transmitted* | — |
| **ADS1115** | `0.001 V` (4x2) | 1 or 2 ADS1115 installed + `SCL`/`SDA` defined | *not transmitted currently* | — |
| **Remain** | *Not measured* | ELRS field exists but is not used currently (one byte only = `%`) | *not used* | `%` |
| **Pitch** | `0.01 degree` | MPU6050 is installed (and `SCL`/`SDA` defined) | `pitch` | `Rad (1/10000)` |
| **Roll** | `0.01 degree` | Same as above | `roll` | `Rad (1/10000)` |
| **Acc X** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Y** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Z** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Temp1** | — | Transmitted | `Temp1` | `°C` |
| **Temp2** | — | Transmitted | `OXS Version` | — |

> **Note:** To analyze if handset can display an RPM value in `YAW` (which is supposed to be in degree; perhaps to redefine on handset).

---

## 3. HoTT Protocol

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **VOLT1** | `0.001 V` | `V1` pin is defined | `GAM Battery 1` | `0.1 V` |
| **VOLT2** | `0.001 V` = `0.001 A` | `V2` pin is defined | `GAM Current` | `0.1 A` |
| **Capacity** | `mAh` | `V2` pin is defined (reset after power down) | `GAM Batt capacity` | `0.01 Ah` |
| **VOLT3** | `0.001 V` | `V3` pin is defined & `TEMP=0` or `255` | `GAM Battery 2` | `0.1 V` |
| **VOLT3 (Temp)** | `0.001 V` | `V3` pin is defined & `TEMP=1` or `2` | `GAM temperature 1` | `degree` |
| **VOLT4** | `0.001 V` | `V4` pin is defined & `TEMP=0` or `255` | `GAM Main voltage` | `0.1 V` |
| **VOLT4 (Temp)** | `0.001 V` | `V4` pin is defined & `TEMP=2` | `GAM temperature 2` | `degree` |
| **Baro Alt** | `cm` | Baro is installed (and `SCL`/`SDA` defined) | `GAM Rel. Altitude` | `m` |
| **Vspeed** | `cm/s` | Baro is installed (and `SCL`/`SDA` defined; uses MPU6050 too if installed) | `GAM Vspeed` | `cm/s` |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | `GPS longitude` | special format |
| **GPS Latitude** | — | Same as above | `GPS latitude` | special format |
| **GPS Speed** | `cm/s` | Same as above | `GPS ground speed` | `km/h` |
| **GPS Course** | `0.01 degree` | Same as above | `GPS heading` | `0.5 degree` |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`; note: some handsets calculate relative alt) | `GPS Alt` | `m` |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | `GPS num sat` | `unit (+100)` |
| **GPS Date** | `YYMMDD0xFF` | Same as above | *not transmitted* | — |
| **GPS Time** | `HHMMSS0x00` | Same as above | *not transmitted* | — |
| **GPS PDOP** | `0.01` | Same as above | *not transmitted* | — |
| **GPS Bearing from Home** | `degree` | Same as above | `GPS bearing` | `degree` |
| **GPS Distance from Home** | `m` | Same as above | `GPS distance` | `m` |
| **GPS Cumulative Distance** | `m` | Same as above | *not transmitted* | — |
| **RPM** | `Hz` | `RPM` pin is defined | `GAM Rpm` | `Hz/10` |
| **ADS1115** | `0.001 V` (4x2) | 1 or 2 ADS1115 installed + `SCL`/`SDA` defined | `Ads1` = cells 1..4, `Ads2` = cells 5 & 6 (max output = `5 V`) | `V` |
| **Pitch** | `0.01 degree` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not available in HoTT* | — |
| **Roll** | `0.01 degree` | Same as above | *not available in HoTT* | — |
| **Acc X** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Y** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Z** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |

> **Additional HoTT GAM Notes:**  
> * `GAM temperature 1` (standalone): *not transmitted*  
> * `GAM temperature 2` (standalone): *not transmitted*  
> * `GAM Airspeed`: *not transmitted*  
> * `GAM Min cell Volt`: *not transmitted*

---

## 4. Jeti Ex Protocol

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **VOLT1** | `0.001 V` | `V1` pin is defined | `Accu volt` | `0.01 V` |
| **VOLT2** | `0.001 V` = `0.001 A` | `V2` pin is defined | `Current` | `0.01 A` |
| **Capacity** | `mAh` | `V2` pin is defined (reset after power down) | `Consumption` | `0.01 Ah` |
| **VOLT3** | `0.001 V` | `V3` pin is defined & `TEMP=0` or `255` | *not transmitted currently* | — |
| **VOLT3 (Temp)** | `0.001 V` | `V3` pin is defined & `TEMP=1` or `2` | `Temp1` | `degree` |
| **VOLT4** | `0.001 V` | `V4` pin is defined & `TEMP=0` or `255` | *not transmitted currently* | — |
| **VOLT4 (Temp)** | `0.001 V` | `V4` pin is defined & `TEMP=2` | `Temp2` | `degree` |
| **Baro Alt** | `cm` | Baro is installed (and `SCL`/`SDA` defined) | `Rel. Altitude` | `dm` |
| **Vspeed** | `cm/s` | Baro is installed (and `SCL`/`SDA` defined; uses MPU6050 too if installed) | `Vspeed` | `cm/s` |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | `longitude` | special format |
| **GPS Latitude** | — | Same as above | `latitude` | special format |
| **GPS Speed** | `cm/s` | Same as above | `GPS ground speed` | `0.1 km/h` |
| **GPS Course** | `0.01 degree` | Same as above | `GPS course` | `degree` |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`; note: some handsets calculate relative alt) | `GPS Alt` | `m` |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | *not transmitted currently* | — |
| **GPS Date** | `YYMMDD0xFF` | Same as above | *not transmitted* | — |
| **GPS Time** | `HHMMSS0x00` | Same as above | *not transmitted* | — |
| **GPS PDOP** | `0.01` | Same as above | *not transmitted* | — |
| **GPS Bearing from Home** | `degree` | Same as above | *not transmitted* | — |
| **GPS Distance from Home** | `m` | Same as above | *not transmitted* | — |
| **GPS Cumulative Distance** | `m` | Same as above | *not transmitted* | — |
| **RPM** | `Hz` | `RPM` pin is defined | `RPM` | `RPM (= Hz * 60)` |
| **ADS1115** | `0.001 V` (4x2) | 1 or 2 ADS1115 installed + `SCL`/`SDA` defined | *not transmitted currently* | — |
| **Pitch** | `0.01 degree` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted currently* | — |
| **Roll** | `0.01 degree` | Same as above | *not transmitted currently* | — |
| **Airspeed** | `cm/s` | MS4525 / SDP3x is installed (and `SCL`/`SDA` defined) | `Airspeed` | `km/h` |
| **Comp. Vspeed** | `cm/s` | Baro + MS4525 / SDP3x are installed | *not transmitted* | — |
| **Acc X** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Y** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Z** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |

## 5. Jeti Exbus Protocol

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **VOLT1** | `0.001 V` | `V1` pin is defined | `Volt 1` | `0.01 V` |
| **VOLT2** | `0.001 V` = `0.001 A` | `V2` pin is defined | `Current` | `0.01 A` |
| **Capacity** | `mAh` | `V2` pin is defined (reset after power down) | `Consumption` | `0.01 Ah` |
| **VOLT3** | `0.001 V` | `V3` pin is defined & `TEMP=0` or `255` | `Volt 3` | `0.01 V` |
| **VOLT3 (Temp)** | `0.001 V` | `V3` pin is defined & `TEMP=1` or `2` | `Temp1` | `degree` |
| **VOLT4** | `0.001 V` | `V4` pin is defined & `TEMP=0` or `255` | `Volt 4` | `0.01 V` |
| **VOLT4 (Temp)** | `0.001 V` | `V4` pin is defined & `TEMP=2` | `Temp2` | `degree` |
| **Baro Alt** | `cm` | Baro is installed (and `SCL`/`SDA` defined) | `Rel. Altitude` | `dm` |
| **Vspeed** | `cm/s` | Baro is installed (and `SCL`/`SDA` defined; uses MPU6050 too if installed) | `Vspeed` | `cm/s` |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | `Gps long` | special format |
| **GPS Latitude** | — | Same as above | `Gps lat` | special format |
| **GPS Speed** | `cm/s` | Same as above | `Gps ground speed` | `0.1 km/h` |
| **GPS Course** | `0.01 degree` | Same as above | `Gps heading` | `degree` |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`; note: some handsets calculate relative alt) | `Gps Alt` | `m` |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | `Gps Sat` | `no unit` |
| **GPS Date** | `YYMMDD0xFF` | Same as above | *not transmitted* | — |
| **GPS Time** | `HHMMSS0x00` | Same as above | *not transmitted* | — |
| **GPS PDOP** | `0.01` | Same as above | *not transmitted* | — |
| **GPS Bearing from Home** | `degree` | Same as above | *not transmitted* | — |
| **GPS Distance from Home** | `m` | Same as above | *not transmitted* | — |
| **GPS Cumulative Distance** | `m` | Same as above | `Gps cum. dist.` | `0.1 km` |
| **RPM** | `Hz` | `RPM` pin is defined | `RPM` | `RPM (= Hz * 60)` |
| **ADS1115** | `0.001 V` (4x2) | 1 or 2 ADS1115 installed + `SCL`/`SDA` defined | *not transmitted currently* | — |
| **Pitch** | `0.01 degree` | MPU6050 is installed (and `SCL`/`SDA` defined) | `Pitch` | `0.1 degree` |
| **Roll** | `0.01 degree` | Same as above | `Roll` | `0.1 degree` |
| **Airspeed** | `cm/s` | MS4525 / SDP3x is installed (and `SCL`/`SDA` defined) | `Airspeed` | `km/h` |
| **Comp. Vspeed** | `cm/s` | Baro + MS4525 / SDP3x are installed | `Comp Vspeed` | `m/s` |
| **Acc X** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Y** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Z** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |

---

## 6. Multiplex Protocol

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **VOLT1** | `0.001 V` | `V1` pin is defined | `Index = 9` | `0.1 V` |
| **VOLT2** | `0.001 V` = `0.001 A` | `V2` pin is defined | `Index = 2` | `0.001 V` (`0.001 A`) |
| **Capacity** | `mAh` | `V2` pin is defined (reset after power down) | `Index = 11` | `mAh` |
| **VOLT3** | `0.001 V` | `V3` pin is defined & `TEMP=0` or `255` | *not transmitted currently* | — |
| **VOLT3 (Temp)** | `0.001 V` | `V3` pin is defined & `TEMP=1` or `2` | `Index = 6` | `0.1 degree` |
| **VOLT4** | `0.001 V` | `V4` pin is defined | *not transmitted currently* | — |
| **Baro Alt** | `cm` | Baro is installed (and `SCL`/`SDA` defined) | `Index = 8` | `m` |
| **Vspeed** | `cm/s` | Baro is installed (and `SCL`/`SDA` defined; uses MPU6050 too if installed) | `Index = 3` | `dm/s` |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | *not transmitted* | — |
| **GPS Latitude** | — | Same as above | *not transmitted* | — |
| **GPS Speed** | `cm/s` | Same as above | `Index = 4` | `0.1 km/h` |
| **GPS Course** | `0.01 degree` | Same as above | `Index = 15` | `0.1 degree` |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`; note: some handsets calculate relative alt) | `Index = 14` | `m` |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | *not transmitted* | — |
| **GPS Date** | `YYMMDD0xFF` | Same as above | *not transmitted* | — |
| **GPS Time** | `HHMMSS0x00` | Same as above | *not transmitted* | — |
| **GPS PDOP** | `0.01` | Same as above | *not transmitted* | — |
| **GPS Bearing from Home** | `degree` | Same as above | `Index = 7` | `0.1 degree` |
| **GPS Distance from Home** | `m` | Same as above | `Index = 13` | `0.1 km` |
| **GPS Cumulative Distance** | `m` | Same as above | `Index = 12` | `0.1 km` |
| **RPM** | — | `RPM` pin is defined | `Index = 5` | `100 RPM` (`100 t/min`) |
| **ADS1115** | `0.001 V` (4x2) | 1 or 2 ADS1115 installed + `SCL`/`SDA` defined | *not transmitted* | — |
| **Pitch** | `0.01 degree` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Roll** | `0.01 degree` | Same as above | *not transmitted* | — |
| **Acc X** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Y** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Z** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |

## 7. IBus (FlySky) Protocol

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **VOLT1** | `0.001 V` | `V1` pin is defined | `EXTERNAL_VOLTAGE` | `0.01 V` |
| **VOLT2** | `0.001 V` = `0.001 A` | `V2` pin is defined | `BAT_CURR` | `0.01 A` |
| **Capacity** | `mAh` | `V2` pin is defined (reset after power down) | `FUEL` | `mAh` |
| **VOLT3** | `0.001 V` | `V3` pin is defined & `TEMP=0` or `255` | *not transmitted currently* | — |
| **VOLT3 (Temp)** | `0.001 V` | `V3` pin is defined & `TEMP=1` or `2` | `TEMPERATURE` | `0.1 degree` |
| **VOLT4** | `0.001 V` | `V4` pin is defined | *not transmitted currently* | — |
| **VOLT4 (Temp)** | `0.001 V` | `V4` pin is defined & `TEMP=2` | `TEMPERATURE` | `0.1 degree` |
| **Baro Alt** | `cm` | Baro is installed (and `SCL`/`SDA` defined) | `ALT` | `cm` |
| **Vspeed** | `cm/s` | Baro is installed (and `SCL`/`SDA` defined; uses MPU6050 too if installed) | `CLIMB_RATE` | `cm/s` |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | `GPS_LON` | `degree` (7 decimals) |
| **GPS Latitude** | — | Same as above | `GPS_LAT` | `degree` (7 decimals) |
| **GPS Speed** | `cm/s` | Same as above | `GROUND_SPEED` | `km/h` |
| **GPS Course** | `0.01 degree` | Same as above | `CMP_HEAD` | `degree` |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`; note: some handsets calculate relative alt) | `GPS_ALT` | `cm` |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | `GPS_STATUS` | `no unit` |
| **GPS Date** | `YYMMDD0xFF` | Same as above | *not transmitted* | — |
| **GPS Time** | `HHMMSS0x00` | Same as above | *not transmitted* | — |
| **GPS PDOP** | `0.01` | Same as above | *not transmitted* | — |
| **GPS Bearing from Home** | `degree` | Same as above | `COG` | `degree` |
| **GPS Distance from Home** | `m` | Same as above | `GPS_DIST` | `m` |
| **GPS Cumulative Distance** | `m` | Same as above | *not transmitted* | — |
| **RPM** | — | `RPM` pin is defined | `RPM` | `RPM` |
| **ADS1115** | `0.001 V` (4x2) | 1 or 2 ADS1115 installed + `SCL`/`SDA` defined | 4 voltages from the first ADS1115 | `0.01 V` |
| **Pitch** | `0.01 degree` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Roll** | `0.01 degree` | Same as above | *not transmitted* | — |
| **Acc X** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Y** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Z** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |

---

## 8. S.Bus2 (Futaba) Protocol

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **VOLT1** | `0.001 V` | `V1` pin is defined | `EXTERNAL_VOLTAGE` | `0.1 V` |
| **VOLT2** | `0.001 V` = `0.001 A` | `V2` pin is defined | `BAT_CURR` | `0.1 A` |
| **Capacity** | `mAh` | `V2` pin is defined (reset after power down) | `FUEL` | `mAh` |
| **VOLT3** | `0.001 V` | `V3` pin is defined & `TEMP=0` or `255` | *not transmitted currently* | — |
| **VOLT3 (Temp)** | `0.001 V` | `V3` pin is defined & `TEMP=1` or `2` | `TEMPERATURE` | `degree` |
| **VOLT4** | `0.001 V` | `V4` pin is defined | *not transmitted currently* | — |
| **VOLT4 (Temp)** | `0.001 V` | `V4` pin is defined & `TEMP=2` | `TEMPERATURE` | `degree` |
| **Baro Alt** | `cm` | Baro is installed (and `SCL`/`SDA` defined) | `ALT` | `m` |
| **Vspeed** | `cm/s` | Baro is installed (and `SCL`/`SDA` defined; uses MPU6050 too if installed) | `CLIMB_RATE` | `0.1 m/s` |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | `GPS_LON` | `degree` |
| **GPS Latitude** | — | Same as above | `GPS_LAT` | `degree` |
| **GPS Speed** | `cm/s` | Same as above | `GROUND_SPEED` | `km/h` |
| **GPS Course** | `0.01 degree` | Same as above | *not transmitted* | — |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`; note: some handsets calculate relative alt) | `GPS_ALT` | `m` |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | `GPS_STATUS` | `no unit` |
| **GPS Date** | `YYMMDD0xFF` | Same as above | *not transmitted* | — |
| **GPS Time** | `HHMMSS0x00` | Same as above | *not transmitted* | — |
| **GPS PDOP** | `0.01` | Same as above | *not transmitted* | — |
| **GPS Bearing from Home** | `degree` | Same as above | *not transmitted* | — |
| **GPS Distance from Home** | `m` | Same as above | *not transmitted* | — |
| **GPS Cumulative Distance** | `m` | Same as above | *not transmitted* | — |
| **RPM** | — | `RPM` pin is defined | `RPM` | `RPM` |
| **ADS1115** | `0.001 V` (4x2) | 1 or 2 ADS1115 installed + `SCL`/`SDA` defined | *not transmitted* | — |
| **Pitch** | `0.01 degree` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Roll** | `0.01 degree` | Same as above | *not transmitted* | — |
| **Airspeed** | `cm/s` | MS4525 is installed (and `SCL`/`SDA` defined) | `Airspeed` | `cm/s` |
| **Comp. Vspeed** | `cm/s` | Baro + MS4525 are installed | *not transmitted* | — |
| **Sbus hold frames** | `%` | Sbus(2) is used | Transmitted as temperature | `no unit (%)` |
| **Sbus failsafe frames** | `count` | Same as above | Transmitted as temperature | `no unit` |
| **Acc X** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Y** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Z** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |

## 9. SRXL2 (Spektrum) Protocol

> **Note:** For SRXL2, there are 2 types of GPS frames: **Binary** and **BCD** (`BCD_LOC` + `BCD_STATS`). The main table below describes the **Binary** GPS format; the separate table underneath covers the **BCD** GPS format.

### Main Table (Binary GPS Frame)

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **VOLT1** | `0.001 V` | `V1` pin is defined | `volts A` | `0.1 V` |
| **VOLT2** | `0.001 V` = `0.001 A` | `V2` pin is defined | `current A` | `0.1 A` |
| **Capacity** | `mAh` | `V2` pin is defined (reset after power down) | `Charge used A` | `mAh` |
| **VOLT3** | `0.001 V` | `V3` pin is defined & `TEMP=0` or `255` | *not transmitted currently* | — |
| **VOLT3 (Temp)** | `0.001 V` | `V3` pin is defined & `TEMP=1` or `2` | `Temperature FET` | `0.1 degree` |
| **VOLT4** | `0.001 V` | `V4` pin is defined | *not transmitted currently* | — |
| **VOLT4 (Temp)** | `0.001 V` | `V4` pin is defined & `TEMP=2` | `Temperature BEC` | `0.1 degree` |
| **Baro Alt** | `cm` | Baro is installed (and `SCL`/`SDA` defined) | `ALT` | `0.1 m` |
| **Vspeed** | `cm/s` | Baro is installed (and `SCL`/`SDA` defined; uses MPU6050 too if installed) | `CLIMB_RATE` | `0.1 m/s` |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | `GPS_LON` | `degree` (7 decimals) |
| **GPS Latitude** | — | Same as above | `GPS_LAT` | `degree` (7 decimals) |
| **GPS Speed** | `cm/s` | Same as above | `GROUND_SPEED` | `km/h` |
| **GPS Course** | `0.01 degree` | Same as above | `Heading` | `0.1 degree` |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`; note: some handsets calculate relative alt) | `GPS_ALT` | `m` (with `1000` offset) |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | `GPS_STATUS` | `no unit` |
| **GPS Date** | `YYMMDD0xFF` | Same as above | *not transmitted* | — |
| **GPS Time** | `HHMMSS0x00` | Same as above | *not transmitted* | — |
| **GPS PDOP** | `0.01` | Same as above | *not transmitted* | — |
| **GPS Bearing from Home** | `degree` | Same as above | *not transmitted* | — |
| **GPS Distance from Home** | `m` | Same as above | *not transmitted* | — |
| **GPS Cumulative Distance** | `m` | Same as above | *not transmitted* | — |
| **RPM** | `Hz` | `RPM` pin is defined | `RPM` | `10 RPM` (`10 tour/min`) |
| **ADS1115** | `0.001 V` (4x2) | 1 or 2 ADS1115 installed + `SCL`/`SDA` defined | 4 voltages from first ADS1115 | `0.01 V` |
| **Pitch** | `0.01 degree` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Roll** | `0.01 degree` | Same as above | *not transmitted* | — |
| **Airspeed** | `cm/s` | MS4525 is installed (and `SCL`/`SDA` defined) | `Airspeed` | `km/h` |
| **Comp. Vspeed** | `cm/s` | Baro + MS4525 are installed | *not transmitted* | — |
| **Acc X** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Y** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |
| **Acc Z** | `0.001 g` | MPU6050 is installed (and `SCL`/`SDA` defined) | *not transmitted* | — |

### SRXL2 BCD GPS Frame (`BCD_LOC` + `BCD_STATS`)

| Field | Measured In | Measured and Transmitted When | Transmitted As | Transmitted In |
| :--- | :--- | :--- | :--- | :--- |
| **GPS Longitude** | — | GPS is installed (and `GPS_TX`, `GPS_RX` defined) | `GPS_LON` | `BCD` (`DDDMMmmmm`, `mm` = decimals of min) |
| **GPS Latitude** | — | Same as above | `GPS_LAT` | `BCD` (`DDDMMmmmm`, `mm` = decimals of min) |
| **GPS Speed** | `cm/s` | Same as above | `GROUND_SPEED` | `BCD` (`knots`) |
| **GPS Course** | `0.01 degree` | Same as above | `Heading` | `BCD` (`0.1 degree`) |
| **GPS Alt** | `cm` | Same as above (`= alt above sea level`) | `GPS_ALT` | `BCD` (`dm`, split on 2 frames + 1 flag `> 1000 m`) |
| **GPS Satellites** | — | Same as above (`+100` when 3D fix) | `GPS_STATUS` | `BCD` (not more than `99`) |
| **GPS Date** | `YYMMDD0xFF` | Same as above | *not transmitted* | — |
| **GPS Time** | `HHMMSS0x00` | Same as above | `GPS_TIME` | `BCD` (`HHMMSS00`) |
| **GPS PDOP** | `0.01` | Same as above | `PDOP` | `BCD` (`0.1`) |

GPS bearing from home        Same as above                                 not transmitted
GPS distance from home       Same as above                                 not transmitted
GPS cumulative distance m    Same as above                                 not transmitted 
