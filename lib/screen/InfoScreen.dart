import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radar_covid/provider/User.dart';
import 'package:http/http.dart' as http;

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late var _response;
  var _covidList = [];
  int index = 0;
  double chartValue = 0;
  String chartLabel = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadData();
    });
  }

  _loadData() async {
    var url = Uri.parse('https://covid19-brazil-api.vercel.app/api/report/v1');
    _response = await http.get(url);
    if (_response.statusCode == 200) {
      setState(() {
        _covidList = jsonDecode(_response.body)['data'] as List;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List user = Provider.of<Users>(context, listen: false).users;
    if (_covidList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Estatisticas'),
          ),
        ),
        body: Container(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    var _currentState = _covidList
        .where((element) => element['state'] == user[0].state)
        .toList();

    setGraficoDados(index) {
      if (index < 0) return;

      if (index != _currentState.length) {
        chartLabel = 'Casos';
        chartValue = double.parse(_currentState[0]['cases'].toString());
      } else {
        chartLabel = 'Mortes';
        chartValue = double.parse(_currentState[0]['deaths'].toString());
      }
    }

    List<PieChartSectionData> loadSatistics() {
      setGraficoDados(index);
      final tamanhoLista = 3;

      return List.generate(tamanhoLista, (i) {
        final isTouched = i == index;
        final fontSize = isTouched ? 18.0 : 14.0;
        final radius = isTouched ? 60.0 : 50.0;
        final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];
        var value;
        var title;
        switch (i) {
          case 0:
            value = double.parse(_currentState[0]['cases'].toString());
            title = "${_currentState[0]['cases']} \n Casos";
            break;
          case 1:
            value = double.parse(_currentState[0]['deaths'].toString());
            title = "${_currentState[0]['deaths']} \n Mortes";
            break;
          default:
            value = 0.0;
            title = "Erro";
        }

        return PieChartSectionData(
          color: color,
          value: value,
          title: title,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Estatisticas!'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 48),
          child: Column(
        children: [
           Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                'Ola ${user[0].name} essas são as estatisticas do estado de ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              user[0].state.toString(),
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.5,
              ),
            ),
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 110,
                    sections: loadSatistics(),
                    pieTouchData: PieTouchData(
                      touchCallback: (touch) => setState(() {
                        index = touch.touchedSection!.touchedSectionIndex;
                        setGraficoDados(index);
                      }),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    chartLabel,
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ),
                  Text(
                    chartValue.toStringAsFixed(0),
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              )
            ],
          ),
        ],
      )),
    );
  }
}
