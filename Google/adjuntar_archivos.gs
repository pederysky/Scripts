function enviarCorreosDesdeSheet() {
  var archivoId = "ID_HOJA_CALCULO"; // ID de Google Sheets
  var hojaNombre = ""; // Nombre de la hoja
  var archivosAdjuntosIds = ["ID_1", "ID_2"]; // IDs de archivos adjuntos

  try {
    var archivo = SpreadsheetApp.openById(archivoId);
    var sheet = archivo.getSheetByName(hojaNombre);
    if (!sheet) throw new Error("Hoja no encontrada: " + hojaNombre);
    
    var datos = sheet.getDataRange().getValues();
    Logger.log("Datos obtenidos: " + datos.length);

    // Obtener archivos adjuntos desde DriveApp
    var archivosAdjuntos = archivosAdjuntosIds.map(id => {
      try {
        return DriveApp.getFileById(id).getBlob();
      } catch (error) {
        Logger.log("No se pudo obtener el archivo con ID: " + id);
        return null;
      }
    }).filter(blob => blob !== null); // Eliminar archivos no encontrados

    for (var i = 1; i < datos.length; i++) {
      var nombre = datos[i][0];
      var asunto = datos[i][1];
      var cuerpo = datos[i][2];
      var correo = datos[i][3];

      if (correo) {
        var mensaje = "Hola " + nombre + ",\n\n" + cuerpo + "\n\nEste es un correo automatizado";

        var opcionesCorreo = { name: 'Automated Email' };

        if (archivosAdjuntos.length > 0) {
          opcionesCorreo.attachments = archivosAdjuntos;
        }

        GmailApp.sendEmail(correo, asunto, mensaje, opcionesCorreo);
      }
    }

    Logger.log("Correos enviados exitosamente.");
  } catch (error) {
    Logger.log("Error: " + error.message);
  }
}
