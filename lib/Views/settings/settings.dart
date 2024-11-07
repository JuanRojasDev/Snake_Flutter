import 'dart:io';
import 'package:flutter/material.dart';
import 'package:disk_space/disk_space.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';

class Settings extends StatefulWidget {
  final Usuario usuario;

  Settings({required this.usuario});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool locationEnabled = false;
  bool callsEnabled = false;
  bool cameraEnabled = false;
  bool microphoneEnabled = false;
  int cacheSize = 0; // Tamaño de caché en MB
  final _secureStorage = FlutterSecureStorage();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool isUserNameExpanded = false;
  bool isEmailExpanded = false;
  bool isPasswordExpanded = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String storageInfo = "";

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _getCacheSize();
    _getStorageInfo();
  }

  Future<void> _loadSettings() async {
    locationEnabled =
        (await _secureStorage.read(key: 'locationEnabled')) == 'true';
    callsEnabled = (await _secureStorage.read(key: 'callsEnabled')) == 'true';
    cameraEnabled = (await _secureStorage.read(key: 'cameraEnabled')) == 'true';
    microphoneEnabled =
        (await _secureStorage.read(key: 'microphoneEnabled')) == 'true';
    setState(() {});
  }

  Future<void> _updatePermissionStatus(String key, bool enabled) async {
    await _secureStorage.write(key: key, value: enabled.toString());
    setState(() {});
  }

  Future<void> _getCacheSize() async {
    final cacheDir = await getTemporaryDirectory();
    int size = await _getFolderSize(cacheDir);
    setState(() {
      cacheSize = (size / (1024 * 1024)).round(); // Convertir a MB
    });
  }

  Future<int> _getFolderSize(Directory dir) async {
    int size = 0;
    await for (FileSystemEntity entity
        in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        size += await entity.length();
      }
    }
    return size;
  }

  Future<void> _clearCache() async {
    final cacheDir = await getTemporaryDirectory();
    cacheDir.deleteSync(recursive: true);
    await _getCacheSize(); // Actualiza el tamaño de la caché después de limpiarla
  }

  Future<void> _getStorageInfo() async {
    if (Platform.isAndroid || Platform.isIOS) {
      double? freeSpace = await DiskSpace.getFreeDiskSpace; // en MB
      double? totalSpace = await DiskSpace.getTotalDiskSpace; // en MB

      if (freeSpace != null && totalSpace != null) {
        setState(() {
          storageInfo =
              "${(freeSpace / 1024).toStringAsFixed(1)}GB/${(totalSpace / 1024).toStringAsFixed(1)}GB";
        });
      }
    }
  }

  void _showChangePasswordDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Cambiar Contraseña",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                // Nueva contraseña
                TextField(
                  controller: _newPasswordController,
                  obscureText:
                      !_isPasswordVisible, // Controla la visibilidad de la nueva contraseña
                  decoration: InputDecoration(
                    labelText: "Nueva Contraseña",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFF5DB075)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                              !_isPasswordVisible; // Cambia el estado
                        });
                        print(
                            'Visibilidad de la contraseña: $_isPasswordVisible');
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Confirmar contraseña
                TextField(
                  controller: _confirmPasswordController,
                  obscureText:
                      !_isConfirmPasswordVisible, // Controla la visibilidad de la confirmación
                  decoration: InputDecoration(
                    labelText: "Confirmar Contraseña",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFF5DB075)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible; // Cambia la visibilidad de la confirmación
                        });
                        print(
                            'Visibilidad de la confirmación de la contraseña: $_isConfirmPasswordVisible');
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Botones de acción (Cancelar / Guardar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(), // Cierra el diálogo
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF898A8D), // Color de fondo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_newPasswordController.text ==
                            _confirmPasswordController.text) {
                          Navigator.of(context)
                              .pop(); // Cierra el diálogo si las contraseñas coinciden
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Contraseña actualizada con éxito")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Las contraseñas no coinciden")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5DB075),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajustes"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cambiar Nombre de Usuario
            ListTile(
              title: Text("Cambiar Nombre de Usuario"),
              subtitle: Text("Usuario Actual: ${widget.usuario.nombres}"),
              trailing: Icon(isUserNameExpanded
                  ? Icons.arrow_drop_down
                  : Icons.arrow_forward_ios),
              onTap: () =>
                  setState(() => isUserNameExpanded = !isUserNameExpanded),
            ),
            if (isUserNameExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    hintText: "Nuevo Nombre",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            Divider(),
            // Mostrar Correo Electrónico
            ListTile(
              title: Text("Cambiar Correo Electrónico"),
              subtitle: Text("Correo Actual: ${widget.usuario.correo}"),
              trailing: Icon(isEmailExpanded
                  ? Icons.arrow_drop_down
                  : Icons.arrow_forward_ios),
              onTap: () => setState(() => isEmailExpanded = !isEmailExpanded),
            ),
            if (isEmailExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Nuevo Correo Electrónico",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),

            Divider(),
            // Cambiar Contraseña
            ListTile(
              title: Text("Cambiar Contraseña"),
              trailing: Icon(
                isPasswordExpanded
                    ? Icons.arrow_drop_down
                    : Icons.arrow_forward_ios,
              ),
              onTap: () {
                setState(() {
                  isPasswordExpanded =
                      !isPasswordExpanded; // Alterna entre expandido/colapsado
                });
                _showChangePasswordDialog(); // Abre el diálogo de cambio de contraseña
              },
            ),
            Divider(),
            // Permisos
            SwitchListTile(
              title: Text("Habilitar Ubicación"),
              value: locationEnabled,
              onChanged: (bool value) {
                setState(() {
                  locationEnabled = value;
                  _updatePermissionStatus('locationEnabled', value);
                });
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text("Habilitar Llamadas"),
              value: callsEnabled,
              onChanged: (bool value) {
                setState(() {
                  callsEnabled = value;
                  _updatePermissionStatus('callsEnabled', value);
                });
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text("Habilitar Cámara"),
              value: cameraEnabled,
              onChanged: (bool value) {
                setState(() {
                  cameraEnabled = value;
                  _updatePermissionStatus('cameraEnabled', value);
                });
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text("Habilitar Micrófono"),
              value: microphoneEnabled,
              onChanged: (bool value) {
                setState(() {
                  microphoneEnabled = value;
                  _updatePermissionStatus('microphoneEnabled', value);
                });
              },
            ),
            Divider(),
            // Almacenamiento
            ListTile(
              title: Text("Almacenamiento"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Espacio Disponible: $storageInfo"),
                  Text("Memoria Caché: ${cacheSize}MB",
                      style: TextStyle(color: Colors.red)),
                ],
              ),
              trailing: Icon(Icons.delete),
              onTap: _clearCache,
            ),
            SizedBox(height: 16),

            // Botón Guardar Cambios
            Spacer(), // Empuja el botón a la parte inferior
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para guardar cambios
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Cambios guardados correctamente")));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5DB075),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15), // Aumenta el tamaño del botón
                ),
                child: Text(
                  'Guardar Cambios',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16), // Aumenta el tamaño del texto
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
