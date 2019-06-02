Disclaimer : I wrote UDPclient.py and UDPserver.py and the server part of the godot simulation (host.gd, ground.gd) but not the HUD or the lift model in godot

# SimulPhys
Physicals process simulator made at Polytech Lille in IMA3 and IMA4

Wiki project page : https://projets-ima.plil.fr/mediawiki/index.php/IMA3/IMA4_2018/2020_P8#Analyse_du_second_concurrent

Collaborators : Quentin Normand, Sebastien Dardenne, Clement Hue, Alex Lagneau, Corto Callerisa

![](https://github.com/Tywacol/SimulPhys/blob/master/img/simulphys.JPG?raw=true)



## Installation

Release is available for windows.

For linux systems you must install [Godot](https://godotengine.org/download/windows) and Python3. 

## Usage
Arguments

For the controller script :
```bash
python3 UDPClient.py --port 1234 --ip 127.0.0.1
```
--port -p : the destination port.

--ip -i : the destination ip adress 

```
For the view script :
```bash
python3 UDPClient.py --port 1234 --ip 127.0.0.1 --export file.csv
```
--port -p : the listening destination port.

--ip -i : the listening ip adress 

--export -e : export the data in CSV format to the file specified

## Contributing

Pull request are closed while we're working on it.

## License
[MIT](https://choosealicense.com/licenses/mit/)

