import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:search_cep/services/via_cep_service.dart';
import 'package:search_cep/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  String _result;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
        actions: <Widget>[
          Text('Tema Dark:'),
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                if (value == true) {
                  DynamicTheme.of(context).setBrightness(Brightness.dark);
                } else {
                  DynamicTheme.of(context).setBrightness(Brightness.light);
                }
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ],
      ),

//this goes in as one of the children in our column

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Cep'),
      maxLength: 8,
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : Text('Consultar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result  ;
      _loading = enable;
      _enableField = !enable;
    });
  }
  String _cep = "",
      _logradouro = "",
      _complemento = "",
      _localidade = "",
      _uf="",
      _unidade="",
      _ibge="",
      _gia="",
      _bairro="";

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  
  Future _searchCep() async {
    _searching(true);

    final String cep = _searchCepController.text;
    if (cep.isNotEmpty) {
      final resultCep = await ViaCepService.fetchCep(cep: cep);

      setState(() {
        if (resultCep.toString() != '' || resultCep.toString() !="erro") {
          _result = resultCep.toJson();
        }
        _bairro = resultCep.bairro;
        _cep = resultCep.cep;
        _logradouro = resultCep.logradouro;
        _complemento = resultCep.complemento;
        _localidade = resultCep.localidade;
        _uf = resultCep.uf;
        _unidade = resultCep.unidade;
        _ibge = resultCep.ibge;
        _gia = resultCep.gia;
        //_result = json.decode(resultCep.bairro)['results'];
      });

      _searching(false);
    } else {
      setState(() {
        Flushbar(
          title: "Entrada Invalida!",
          message: "O $cep é invalido!",
          duration: Duration(seconds: 3),
        )..show(context);
        _searching(false);
      });
    }
  }

  Widget _buildResultForm() {
    return Column(children: <Widget>[
      TextField(
        decoration: InputDecoration(labelText: 'CEP:'),
        controller: TextEditingController(text: _cep.toString()),
        enabled: true,
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Logradouro:'),
        controller: TextEditingController(text: _logradouro.toString()),
        enabled: true,
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Complemento:'),
        controller: TextEditingController(text: _complemento.toString()),
        enabled: true,
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Localidade:'),
        controller: TextEditingController(text: _localidade.toString()),
        enabled: true,
      ),
      TextField(
        decoration: InputDecoration(labelText: 'UF:'),
        controller: TextEditingController(text: _uf.toString()),
        enabled: true,
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Unidade:'),
        controller: TextEditingController(text: _unidade.toString()),
        enabled: true,
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Ibge:'),
        controller: TextEditingController(text: _ibge.toString()),
        enabled: true,
      ),
      TextField(
        decoration: InputDecoration(labelText: 'GIA:'),
        controller: TextEditingController(text: _gia.toString()),
        enabled: true,
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Bairro:'),
        controller: TextEditingController(text: _bairro.toString()),
        enabled: true,
      ),
    ]);
  }
}
