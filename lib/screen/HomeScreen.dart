import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radar_covid/provider/User.dart';
import 'package:radar_covid/utils/app_routes.dart';

class HomeScreem extends StatefulWidget {
  const HomeScreem({Key? key}) : super(key: key);

  static const List<String> _stateList = <String>[
    "Acre",
    "Alagoas",
    "Amapá",
    "Amazonas",
    "Bahia",
    "Ceará",
    "Distrito Federal",
    "Espírito Santo",
    "Goiás",
    "Maranhão",
    "Mato Grosso",
    "Mato Grosso do Sul",
    "Minas Gerais",
    "Pará",
    "Paraíba",
    "Paraná",
    "Pernambuco",
    "Piauí",
    "Rio de Janeiro",
    "Rio Grande do Norte",
    "Rio Grande do Sul",
    "Rondônia",
    "Roraima",
    "Santa Catarina",
    "São Paulo",
    "Sergipe",
    "Tocantins"
  ];

  @override
  _HomeScreemState createState() => _HomeScreemState();
}

class _HomeScreemState extends State<HomeScreem> {
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  void _saveForm() {
    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    final user = User(
      name: _formData['name'].toString(),
      city: _formData['city'].toString(),
      state: _formData['state'].toString(),
    );

    final users = Provider.of<Users>(context, listen: false);

    users.addUser(user);

    Navigator.of(context).pushNamed(AppRoutes.INFO).then((_) {
      users.deleteUser();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Center(child: Text("Pagina Inicial")),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Preencha o formulario abaixo para continuar!",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Nome"),
                onSaved: (value) => _formData['name'] = value!,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'O nome é um campo obrigatorio!';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Cidade"),
                onSaved: (value) => _formData['city'] = value!,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'A cidade é um campo obrigatorio!';
                  }
                  return null;
                },
              ),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return HomeScreem._stateList;
                  }
                  return HomeScreem._stateList.where(
                    (state) => state.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                  );
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(labelText: "Estado"),
                    focusNode: focusNode,
                    onSaved: (value) => _formData['state'] = value!,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'O estado é um campo obrigatorio!';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 4),
                  onPressed: () => _saveForm(),
                  child: Text("Visualizar Estatísticas"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
