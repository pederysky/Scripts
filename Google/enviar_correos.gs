function enviarCorreosDesdeSheet() {
  var archivoId = "ID_DEL_ARCHIVO"; // Aquí pones el ID del archivo de Google Sheets
  var hojaNombre = "NOMBRE_DE_LA_HOJA"; // Aquí pones el nombre de la hoja que quieres usar

  // Abre el archivo y la hoja
  var sheet = SpreadsheetApp.openById(archivoId).getSheetByName(hojaNombre);
  var datos = sheet.getDataRange().getValues(); // Obtiene todos los datos de la hoja

  for (var i = 1; i < datos.length; i++) { // Empieza en 1 para saltar los encabezados
    var nombre = datos[i][0]; // Columna A - Nombre
    var asunto = datos[i][1]; // Columna B - Asunto
    var cuerpo = datos[i][2]; // Columna C - Cuerpo
    var correo = datos[i][3]; // Columna D - Correo

    if (correo) { // Evitar filas vacías
      var mensaje = "Hola " + nombre + ",\n\n" + cuerpo + "\n\nEste es un correo automatizado";
      GmailApp.sendEmail(correo, asunto, mensaje);
    }
  }

  Logger.log("Correos enviados exitosamente.");
}
