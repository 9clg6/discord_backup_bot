String formatPublicPem(String pem) {
  final beginToken = '-----BEGIN PUBLIC KEY-----';
  final endToken = '-----END PUBLIC KEY-----';

  pem = pem.replaceAll(beginToken, '').replaceAll(endToken, '');
  pem = pem.replaceAll(RegExp(r'\s+'), ''); // Supprime tous les espaces
  pem = pem.replaceAllMapped(
      RegExp(r'.{1,64}'),
      (match) =>
          '${match.group(0)}\n'); // Ajoute des retours à la ligne toutes les 64 caractères
  return '$beginToken\n$pem$endToken';
}

String formatPrivatePem(String pem) {
  final beginToken = '-----BEGIN PRIVATE KEY-----';
  final endToken = '-----END PRIVATE KEY-----';

  pem = pem.replaceAll(beginToken, '').replaceAll(endToken, '');
  pem = pem.replaceAll(RegExp(r'\s+'), ''); // Supprime tous les espaces
  pem = pem.replaceAllMapped(
      RegExp(r'.{1,64}'),
      (match) =>
          '${match.group(0)}\n'); // Ajoute des retours à la ligne toutes les 64 caractères
  return '$beginToken\n$pem\n$endToken';
}
